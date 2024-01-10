import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/config/config.dart';
import 'package:feastique/models/models.dart';
import 'package:feastique/screens/manager_orders_page/manager_orders_page.dart';
import 'package:feastique/screens/manager_orders_page/manager_orders_provider.dart';
import 'package:feastique/screens/manager_reservations_page/manager_reservations_page.dart';
import 'package:feastique/screens/manager_reservations_page/manager_reservations_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ManagerHomePageProvider with ChangeNotifier{
  int selectedScreenIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  WrapperHomePageProvider wrapperHomePageProvider;
  Place? place;
  bool isLoading = false;
  Image? image;
  String? name;
  int? capacity;

  double spentAllTime = 0;
  double spentLastMonth = 0;
  int seatedPeopleNoAllTime = 0;
  int seatedLastMonth = 0;

  
  List<Widget>? screens;

  List<BottomNavigationBarItem>? screenLabels;

  ManagerHomePageProvider(BuildContext context, this.wrapperHomePageProvider){
    initData(wrapperHomePageProvider);
    getPlace(context);
    getAnalytics(context);
  }

  void initData(WrapperHomePageProvider wrapperHomePageProvider){
    screens = <Widget>[
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ManagerReservationsPageProvider>(create: (context) => ManagerReservationsPageProvider(context, wrapperHomePageProvider),),
          ChangeNotifierProvider.value(value: wrapperHomePageProvider)
        ],
        builder: (context, _) {
          return ManagerReservationsPage();
        }
      ),
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ManagerOrdersPageProvider>(create: (context) => ManagerOrdersPageProvider(context, wrapperHomePageProvider),),
          ChangeNotifierProvider.value(value: wrapperHomePageProvider)
        ],
        builder: (context, _) {
          return ManagerOrdersPage();
        }
      ),
    ];
    screenLabels = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        label: "Rezervări",
        icon: Image.asset(localAsset("reservation"), width: 20,)
      ),
      BottomNavigationBarItem(
        label: "Comenzi",
        icon: Image.asset(localAsset("orders"), width: 20,)
      ),
    ];
    notifyListeners();
  }

  Future<void> getAnalytics(BuildContext context) async{
    _loading();
    var user = context.read<User?>();

    var place = (await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("managed_places").get()).docs.first;


    var query = await place.reference.collection("reservations").get();
    for(int i = 0; i < query.docs.length; i++){
      if(DateTime.now().toLocal().difference(DateTime.fromMillisecondsSinceEpoch(query.docs[i].data()['date_created'].millisecondsSinceEpoch)).inDays <= 30)
        {
          seatedLastMonth += int.parse(query.docs[i].data()['number_of_guests'].toString());
        }
      seatedPeopleNoAllTime += int.parse(query.docs[i].data()['number_of_guests'].toString());
      var query1 = await query.docs[i].reference.collection("orders").where("accepted", isEqualTo: true).get();
      for(int j = 0; j < query1.docs.length; j++){
        print(query1.docs[j].data());
        double sum = 0;
        for(int k = 0; k < query1.docs[j].data()['items'].length; k++){
          var item = query1.docs[j].data()['items'][k];
          sum += item['item']['price'] == null ? 0 : item['item']['price'] * item['count'];
        }
        if(DateTime.now().toLocal().difference(DateTime.fromMillisecondsSinceEpoch(query.docs[i].data()['date_created'].millisecondsSinceEpoch)).inDays <= 30)
        {
          spentLastMonth += sum;
        }
      spentAllTime += sum;
      }
    }

    _loading();

    notifyListeners();
  }

  Future<void> getPlace(BuildContext context) async{
    _loading();
    var user = Provider.of<User?>(context, listen: false);
    var id = (await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("managed_places").get()).docs.first.id;
    var place = await FirebaseFirestore.instance.collection("places").doc(id).get();
    this.place = docToPlace(place);

    name = this.place!.name;
    capacity = this.place!.capacity;

    image = await getImage(id);

    _loading();
    notifyListeners();
  }

  void changePlaceName(String name){
    this.name = name;

    notifyListeners();
  }
  void changeCapacity(int capacity){
    this.capacity = capacity;

    notifyListeners();
  }

  Future<Image> getImage(String id) async{
    var image = await FirebaseStorage.instance.ref("places/$id/0.jpg")
    .getData();
    return Image.memory(
      image!,
      alignment: FractionalOffset.topCenter,
      fit: BoxFit.cover,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    );
  }

  void updateData(BuildContext context) async{
    _loading();
    if(name != null && name != ""){
      await FirebaseFirestore.instance.collection('places').doc(place!.id).set(
        {
          "name": name 
        },
        SetOptions(merge: true)
      );
    }
    if(capacity != null && capacity != 0){
      await FirebaseFirestore.instance.collection('places').doc(place!.id).set(
        {
          "capacity": capacity 
        },
        SetOptions(merge: true)
      );
    }

    getPlace(context);

    _loading();

    notifyListeners();
  }

  void updateSelectedScreenIndex(int index){
    selectedScreenIndex = index;

    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}