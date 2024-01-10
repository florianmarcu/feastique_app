import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/models/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
export 'package:provider/provider.dart';

class ReservationsPageProvider with ChangeNotifier{
  
  //List<Reservation>? reservations;
  List<Reservation>? pastReservations;
  List<Reservation>? upcomingReservations; 

  ReservationsPageProvider(BuildContext context){
    getData(context);
  }
  
  Future<void> getData(BuildContext context) async{
    var user = Provider.of<User?>(context, listen: false);
    
    /// Get past reservations
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("reservations")
    .where('date_start', isLessThan: Timestamp.fromDate(DateTime.now().add(Duration(minutes: -30)).toLocal()))
    .get()
    .then((query) => pastReservations = query.docs.map((doc) => reservationDataToReservation(doc.id, doc.data())).toList());
    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("reservations")
    .where('date_start', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().add(Duration(minutes: -30)).toLocal()))
    .where('canceled', isEqualTo: true)
    .get()
    .then((query) => pastReservations!.addAll(query.docs.map((doc) => reservationDataToReservation(doc.id, doc.data())).toList()));
    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("reservations")
    .where('date_start', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().add(Duration(minutes: -30)).toLocal()))
    .where('claimed', isEqualTo: true)
    .get()
    .then((query) => pastReservations!.addAll(query.docs.map((doc) => reservationDataToReservation(doc.id, doc.data())).toList()));
    pastReservations!.sort((a, b) => b.dateStart.millisecondsSinceEpoch - a.dateStart.millisecondsSinceEpoch);

    /// Get upcoming reservations
    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("reservations")
    .where('date_start', isGreaterThan: Timestamp.fromDate(DateTime.now().add(Duration(minutes: -30)).toLocal()))
    .get()
    .then((query) => upcomingReservations = query.docs.map((doc) => reservationDataToReservation(doc.id, doc.data())).toList());
    upcomingReservations!.removeWhere((reservation) => reservation.accepted == false || reservation.canceled == true || reservation.claimed == true);
    upcomingReservations!.sort((a, b) => b.dateStart.millisecondsSinceEpoch - a.dateStart.millisecondsSinceEpoch);

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
}