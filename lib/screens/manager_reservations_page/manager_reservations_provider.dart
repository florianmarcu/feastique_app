import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/models/models.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
export 'package:provider/provider.dart';

class ManagerReservationsPageProvider with ChangeNotifier{

  List<Reservation>? pastReservations;
  List<Reservation>? pendingReservations;
  List<Reservation>? activeReservations;
  BuildContext context;
  WrapperHomePageProvider wrapperHomePageProvider;

  ManagerReservationsPageProvider(this.context, this.wrapperHomePageProvider){
    getData();
  }

  Future<void> getData() async{
    var user = Provider.of<User?>(context, listen: false);

    var place = (await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("managed_places").get()).docs.first;
    
    try {
      /// Get pending reservations
      await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("managed_places").doc(place.id).collection("reservations")
      // .where('canceled', isNull: true)
      //.where('accepted', isNull: true)
      .orderBy("date_start", descending: true)
      .get()
      .then((query) => pendingReservations = query.docs.map((doc) => reservationDataToReservation(doc.id, doc.data())).toList());
      pendingReservations!.removeWhere((reservation) => reservation.accepted != null || reservation.canceled);

      /// Get processed reservations   
      await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("managed_places").doc(place.id).collection("reservations")
      .where('accepted', isEqualTo: true)
      // .orderBy("date_start")
      .get()
      .then((query) => pastReservations = query.docs.map((doc) => reservationDataToReservation(doc.id, doc.data())).toList());
      await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("managed_places").doc(place.id).collection("reservations")
      .where('accepted', isEqualTo: false)
      .get()
      .then((query) => pastReservations!.addAll(query.docs.map((doc) => reservationDataToReservation(doc.id, doc.data())).toList()));
      pastReservations!.removeWhere((reservation) => reservation.canceled);
      pastReservations!.sort(((a, b) => b.dateStart.millisecondsSinceEpoch - a.dateStart.millisecondsSinceEpoch));

      /// Get active reservations
      await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("managed_places").doc(place.id).collection("reservations")
      .where('active', isEqualTo: true)
      .orderBy("date_start", descending: true)
      .get()
      .then((query) => activeReservations = query.docs.map((doc) => reservationDataToReservation(doc.id, doc.data())).toList());

    }
    catch(err){}

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

  void acceptReservation(Reservation reservation) async{
    await reservation.userReservationRef!.set(
      {
        "accepted": true,
      },
      SetOptions(merge: true)
    );
    await reservation.placeReservationRef!.set(
      {
        "accepted": true,
      },
      SetOptions(merge: true)
    );
    
    getData();

    notifyListeners();
  }

  void declineReservation(Reservation reservation) async{
    await reservation.userReservationRef!.set(
      {
        "accepted": true,
      },
      SetOptions(merge: true)
    );
    await reservation.placeReservationRef!.set(
      {
        "accepted": true,
      },
      SetOptions(merge: true)
    );
    
    getData();

    notifyListeners();
  }

  void activateReservation(Reservation reservation) async{
    await reservation.userReservationRef!.set(
      {
        "claimed": true,
        "active": true,
      },
      SetOptions(merge: true)
    );
    await reservation.placeReservationRef!.set(
      {
        "claimed": true,
        "active": true,
      },
      SetOptions(merge: true)
    );
    
    getData();

    notifyListeners();
  }

  void deactivateReservation(Reservation reservation) async{
    await reservation.userReservationRef!.set(
      {
        "active": false,
      },
      SetOptions(merge: true)
    );
    await reservation.placeReservationRef!.set(
      {
        "active": false,
      },
      SetOptions(merge: true)
    );
    
    getData();

    notifyListeners();
  }

}