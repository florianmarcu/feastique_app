import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/models/models.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
export 'package:provider/provider.dart';

class ManagerOrdersPageProvider with ChangeNotifier{
  List<TableOrder>? orders;
  BuildContext context;
  bool isLoading = false;
  WrapperHomePageProvider wrapperHomePageProvider;

  ManagerOrdersPageProvider(this.context, this.wrapperHomePageProvider){
    getData();
  }

  Future<void> getData() async{

    var user = context.read<User?>();

    var place = (await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("managed_places").get()).docs.first;

    orders = [];

    var query = await FirebaseFirestore.instance.collectionGroup("reservations")
    .where("active", isEqualTo: true)
    .where("place_id", isEqualTo: place.id)
    .get();

    for(int i = 0; i < query.docs.length; i++){
      var doc = query.docs[i];
      var reservation = reservationDataToReservation(doc.id, doc.data());
      if(!doc.reference.toString().contains("managed_places")){
        var query = await doc.reference.collection("orders").get();
        for(int i = 0; i < query.docs.length; i++){
          var doc = query.docs[i];
          print(doc.data().containsKey("accepted"));
          if(doc.data()['accepted'] == null)
            orders!.add(orderDataToOrder(reservation, doc.id, doc.data(),));
        }
      }
    }
    
    notifyListeners();
  }

  Future<void> acceptOrder(TableOrder order) async{
    _loading();
    
    await order.reservation.placeReservationRef!.collection("orders").doc(order.id)
    .set(
      {
        "accepted" : true
      },
      SetOptions(merge: true)
    );

    await order.reservation.userReservationRef!.collection("orders").doc(order.id)
    .set(
      {
        "accepted" : true
      },
      SetOptions(merge: true)
    );
    _loading();

    notifyListeners();
  }

  Future<void> refuseOrder(TableOrder order) async{
    _loading();

    await order.reservation.placeReservationRef!.collection("orders").doc(order.id)
    .set(
      {
        "accepted" : true
      },
      SetOptions(merge: true)
    );

    await order.reservation.userReservationRef!.collection("orders").doc(order.id)
    .set(
      {
        "accepted" : true
      },
      SetOptions(merge: true)
    );

    _loading();

    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}