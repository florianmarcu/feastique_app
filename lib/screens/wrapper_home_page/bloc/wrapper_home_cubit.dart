import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:feastique/config/config.dart';
import 'package:feastique/models/models.dart';
import 'package:feastique/screens/app/bloc/app_cubit.dart';
import 'package:feastique/screens/discover_page/discover_page.dart';
import 'package:feastique/screens/discover_page/discover_provider.dart';
import 'package:feastique/screens/home_page/home_page.dart';
import 'package:feastique/screens/home_page/home_provider.dart';
import 'package:feastique/screens/profile_page/profile_page.dart';
import 'package:feastique/screens/profile_page/profile_provider.dart';
import 'package:feastique/screens/reservations_page/reservations_page.dart';
import 'package:feastique/screens/reservations_page/reservations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

part 'wrapper_home_state.dart';

class WrapperHomeCubit extends Cubit<WrapperHomeState> {
  WrapperHomeCubit(BuildContext context) : super(WrapperHomeState()){
    getData(context);
  }


  void getData(BuildContext context) async{
    _loading();

    ///Get 'currentUser' as UserProfile (with full data from both FirebaseAuth and Cloud Firestore)
    await updateCurrentUser(context);

    ///Get the configuration data from Cloud Firestore (such as available cities)
    var query = FirebaseFirestore.instance.collection("config").doc("config");
    var doc = await query.get();
    updateConfigData(doc.data());
    var newCity = state.configData!['cities'][state.configData!['main_city']];
    newCity!.addAll({"id": state.configData!['main_city']});
    updateMainCityData(newCity);
    

    var newScreens = <Widget>[
      ChangeNotifierProvider<HomePageProvider>(
        create: (context) => HomePageProvider(state.currentUser),
        builder: (context, _) {
          return HomePage();
        }
      ),
      // ChangeNotifierProvider<DiscoverPageProvider>(
      //   create: (context) => DiscoverPageProvider(context, state.mainCity!, this),
      //   builder: (context, _) {
      //     return DiscoverPage(context);
      //   }
      // ),
      ChangeNotifierProvider<ReservationsPageProvider>(
        create: (context) => ReservationsPageProvider(context),
        builder: (context, _) {
          return ReservationsPage();
        }
      ),
      ChangeNotifierProvider<ProfilePageProvider>(
        create: (context) => ProfilePageProvider(context, state.currentUser!, state.currentUser!.phoneNumber, state.currentUser!.displayName),
        builder: (context, _) {
          return ProfilePage();
        }
      ),
    ];
    updateScreens(newScreens);

    /// Check if there's an active reservation
    /// If there is, assign it to the 'activeReservation'
    await FirebaseFirestore.instance.collection('users').doc(state.currentUser!.uid).collection("reservations")
    .where("active", isEqualTo: true)
    .get()
    .then((query) {
      if(query.docs.length > 0){
        updateActiveReservation(reservationDataToReservation(query.docs[0].id, query.docs[0].data()));
      }
    });

    _loading();
  }

  void updateActiveReservation(Reservation activeReservation){
    emit(state.copyWith(activeReservation: activeReservation));
  }

  Future<void> updateCurrentUser(BuildContext context) async{
    var appState = context.read<AppCubit?>()?.state;
    UserProfile? currentUser; 
    if(appState is AuthenticatedAppState){
      currentUser = await userToUserProfile(appState.user);
    }

    emit(state.copyWith(currentUser: currentUser));
  }

  void updateConfigData(Map<String, dynamic>? data){
    emit(state.copyWith(configData: data));
  }

  void updateScreens(List<Widget>? screens){
    emit(state.copyWith(screens: screens));
  }

  void updateData() async{
    _loading();

    var newScreens = <Widget>[
      ChangeNotifierProvider<HomePageProvider>(
        create: (context) => HomePageProvider(state.currentUser),
        builder: (context, _) {
          return HomePage();
        }
      ),
      // ChangeNotifierProvider<DiscoverPageProvider>(
      //   create: (context) => DiscoverPageProvider(context, state.mainCity!, this),
      //   builder: (context, _) {
      //     return DiscoverPage(context);
      //   }
      // ),
      ChangeNotifierProvider<ReservationsPageProvider>(
        create: (context) => ReservationsPageProvider(context),
        builder: (context, _) {
          return ReservationsPage();
        }
      ),
      ChangeNotifierProvider<ProfilePageProvider>(
        create: (context) => ProfilePageProvider(context, state.currentUser!, state.currentUser!.phoneNumber, state.currentUser!.displayName),
        builder: (context, _) {
          return ProfilePage();
        }
      ),
    ];

    updateScreens(newScreens);

    _loading();
  }

  void updateSelectedScreenIndex(int index){
    emit(state.copyWith(selectedScreenIndex: index));
  }

  void updateMainCityData(city){
    emit(state.copyWith(mainCity: city));
  }

  void updateMainCity(String city){
    _loading();

    var newMainCity = Map.from(state.configData!['cities'][city]);
    newMainCity.addAll({"id": city});
    updateMainCityData(newMainCity);

    /// Update screens
    updateData();

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
  }

  void updateCurrentLocation(LocationData location){
    emit(state.copyWith(currentLocation: location));
  }

  void _loading(){
    emit(state.copyWith(isLoading: !state.isLoading));
  }
}