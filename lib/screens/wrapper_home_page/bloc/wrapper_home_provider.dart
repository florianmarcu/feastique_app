import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/config/config.dart';
import 'package:feastique/models/models.dart';
import 'package:feastique/screens/discover_page/discover_page.dart';
import 'package:feastique/screens/discover_page/discover_provider.dart';
import 'package:feastique/screens/home_page/home_page.dart';
import 'package:feastique/screens/home_page/home_provider.dart';
import 'package:feastique/screens/profile_page/profile_page.dart';
import 'package:feastique/screens/profile_page/profile_provider.dart';
import 'package:feastique/screens/reservations_page/reservations_page.dart';
import 'package:feastique/screens/reservations_page/reservations_provider.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class WrapperHomePageProvider with ChangeNotifier{
  
  /// Configuration data about the cities
  Map<String, dynamic>? configData;
  /// Configuration data about the assets
  Map<String, dynamic>? assetsData;
  /// The cities available in the app
  List<Map<String, dynamic>>? cities;
  /// The main city selected in the app
  Map<String, dynamic>? mainCity;
  UserProfile? currentUser; 
  LocationData? currentLocation;
  Reservation? activeReservation;
  int selectedScreenIndex = 0;
  bool isLoading = false;

  PageController pageController = PageController(initialPage: 1);

  List<Widget> screens = [];

  List<BottomNavigationBarItem> screenLabels = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      label: "Acasă",
      icon: Icon(Icons.home)
    ),
    BottomNavigationBarItem(
      label: "Descoperă",
      icon: Icon(Icons.search)
    ),
    BottomNavigationBarItem(
      label: "Rezervări",
      icon: Image.asset(localAsset('reservation'), width: 19,)
    ),
    BottomNavigationBarItem(
      label: "Profil",
      icon: Icon(Icons.person)
    ),
  ];


  WrapperHomePageProvider(BuildContext context){
    getData(context);
    getLocation();
  }

  void getData(BuildContext context) async{
    _loading();

    ///Get 'currentUser' as UserProfile (with full data from both FirebaseAuth and Cloud Firestore)
    currentUser = await userToUserProfile(context.read<User?>());

    ///Get the configuration data from Cloud Firestore (such as available cities)
    var query = FirebaseFirestore.instance.collection("config").doc("config");
    var doc = await query.get();
    configData = doc.data(); 
    mainCity = configData!['cities'][configData!['main_city']];
    mainCity!.addAll({"id": configData!['main_city']});
    

    screens = <Widget>[
      ChangeNotifierProvider<HomePageProvider>(
        create: (context) => HomePageProvider(currentUser),
        builder: (context, _) {
          return HomePage();
        }
      ),
      ChangeNotifierProvider<DiscoverPageProvider>(
        create: (context) => DiscoverPageProvider(context, mainCity!, this),
        builder: (context, _) {
          return DiscoverPage(context);
        }
      ),
      ChangeNotifierProvider<ReservationsPageProvider>(
        create: (context) => ReservationsPageProvider(context),
        builder: (context, _) {
          return ReservationsPage();
        }
      ),
      ChangeNotifierProvider<ProfilePageProvider>(
        create: (context) => ProfilePageProvider(context, currentUser!, currentUser!.phoneNumber, currentUser!.displayName),
        builder: (context, _) {
          return ProfilePage();
        }
      ),
    ];

    /// Check if there's an active reservation
    /// If there is, assign it to the 'activeReservation'
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection("reservations")
    .where("active", isEqualTo: true)
    .get()
    .then((query) {
      if(query.docs.length > 0)
        activeReservation = reservationDataToReservation(query.docs[0].id, query.docs[0].data());
    });
    

    notifyListeners();

    _loading();
  }

  void updateData() async{
    _loading();

    screens = [];
    //print(mainCity!['id']);

    screens = <Widget>[
      ChangeNotifierProvider<HomePageProvider>(
        create: (context) => HomePageProvider(currentUser),
        builder: (context, _) {
          return HomePage();
        }
      ),
      ChangeNotifierProvider<DiscoverPageProvider>(
        create: (context) => DiscoverPageProvider(context, mainCity!, this),
        builder: (context, _) {
          return DiscoverPage(context);
        }
      ),
      ChangeNotifierProvider<ReservationsPageProvider>(
        create: (context) => ReservationsPageProvider(context),
        builder: (context, _) {
          return ReservationsPage();
        }
      ),
      ChangeNotifierProvider<ProfilePageProvider>(
        create: (context) => ProfilePageProvider(context, currentUser!, currentUser!.phoneNumber, currentUser!.displayName),
        builder: (context, _) {
          return ProfilePage();
        }
      ),
    ];

    notifyListeners();

    _loading();
  }

  void updateSelectedScreenIndex(int index){
    selectedScreenIndex = index;

    notifyListeners();
  }

  void updateMainCity(String city){
    _loading();

    mainCity = configData!['cities'][city];
    mainCity!.addAll({"id": city});

    /// Update screens
    updateData();

    notifyListeners();

    _loading();
  }

  /// Asks for permissions and gets the location for the user
  Future<void> getLocation() async{
    var location = new Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if(!serviceEnabled){
      serviceEnabled = await location.requestService();
      if(!serviceEnabled)
        return;
    }
    
    permissionGranted = await location.hasPermission();
    if(permissionGranted == PermissionStatus.denied || permissionGranted == PermissionStatus.deniedForever){
      permissionGranted = await location.requestPermission();
      if(permissionGranted == PermissionStatus.denied || permissionGranted == PermissionStatus.deniedForever)
        return;
    }

    currentLocation = await location.getLocation();

    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}