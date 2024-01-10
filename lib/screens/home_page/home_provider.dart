import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/models/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePageProvider with ChangeNotifier{
  bool isLoading = false;
  List<Reservation>? claimedReservations;
  UserProfile? currentUser;
  bool? noClaimedReservations;

  HomePageProvider(this.currentUser){
    getData();
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

  Future<Place?> getFirstPlace() async{
    var id = claimedReservations!.length != 0 ? claimedReservations![0].placeId : "";
    //print(id);
    if(id == ""){
      return null;
    }
    var doc = await FirebaseFirestore.instance.collection("places").doc(id)
    .get();
    return docToPlace(doc);
  }

  Future<List<Place>?> getRecommendations() async{
    var place = await getFirstPlace();
    var types = place!.types!;
    var placesAsDocs = [];
    for(int i = 0; i < types.length; i++){
      var query = await FirebaseFirestore.instance.collection("places")
      .get();
      for(int j = 0; j < query.docs.length; j++)
        if(query.docs[j].data()['types'].contains(types[i]))
          placesAsDocs.add(query.docs[j]);
    }
    int max = 0;

    var maxDoc, secondMaxDoc, thirdMaxDoc;
    print(placesAsDocs.length.toString() + " LUNG");
    for(int i = 0; i < placesAsDocs.length; i++){
      if(place.id != placesAsDocs[i].id){
        int s = 0;
        for(int j = 0; j < placesAsDocs.length; j++){
          if(i!= j && placesAsDocs[i].id ==placesAsDocs[j].id)
            s += 1;
        }
        if (s >= max){
          max = s;
          thirdMaxDoc = secondMaxDoc;
          secondMaxDoc = maxDoc;
          maxDoc = placesAsDocs[i];
        }
      }
    }
    print(maxDoc.id.toString() + secondMaxDoc.id.toString() + thirdMaxDoc.id.toString());
    if(maxDoc == null && secondMaxDoc == null && thirdMaxDoc == null)
      return null;
    return [docToPlace(maxDoc), docToPlace(secondMaxDoc), docToPlace(thirdMaxDoc)];
  }

  Future<void> getData() async{
    _loading();
    var user = currentUser!;
    var query = await FirebaseFirestore.instance.collectionGroup('reservations')
    .where("guest_id", isEqualTo: user.uid)
    .where("claimed", isEqualTo: true)
    .get();
    claimedReservations = [];
    for(int i = 0; i < query.docs.length; i++){
      if(!query.docs[i].reference.path.contains("managed_places")){
        var reservation = reservationDataToReservation(query.docs[i].id, query.docs[i].data());
        claimedReservations!.add(reservation);
      }
    }
    claimedReservations!.sort((a,b) => b.dateStart.millisecondsSinceEpoch - a.dateStart.millisecondsSinceEpoch);

    noClaimedReservations = claimedReservations!.length == 0;
    print(noClaimedReservations);
    _loading();

    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;
  }
}