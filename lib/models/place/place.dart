import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Place{
  final String id; // Imported from the database
  final String name; // Imported from the database
  final Future<Image> image; // Imported from the database
  final String? description; // Imported from the database
  final GeoPoint location; // Imported from the database
  final int cost; // Imported from the database
  final String ambience;
  final int capacity;
  final Map<String, dynamic>? discounts;
  //final Future<List<Uint8List>> images; // The Place images from Firebase Storage
  final Future<String>? address; // The Street&No of the Place
  /// A reference to the 'users/{usersId}/managed_place/{managed_place}' in the database
  /// Contains some data about the place, and the 'reservations' and 'scanned_codes' subcollections. 
  final DocumentReference? reference;
  final Map<String, dynamic>? schedule;
  final Map<String, dynamic>? deals;
  final List<dynamic>? types;
  final dynamic menu; // A link to a webpage containing the Place's menu
  final bool? hasOpenspace;
  final bool? hasReservations;
  final bool? isPartner;
  final bool? preferPhone;
  final int? phoneNumber;
  final String? tipMessage;
  Image? finalImage;

  Place({
    required this.cost,
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.location,
    required this.ambience,
    required this.capacity,
    this.discounts,
    this.address,
    this.reference,
    required  this.schedule,
    this.deals,
    this.types,
    this.menu,
    this.hasOpenspace,
    this.hasReservations,
    this.isPartner,
    this.preferPhone,
    this.phoneNumber,
    this.tipMessage
  }){
    image.then((image) => finalImage = image);
  }
}

Place docToPlace(DocumentSnapshot doc){
    Future<String>? address;
    var profileImage = _getImage(doc.id);
    var place = doc.data() as Map<String, dynamic>;
    return Place(
      cost: place['cost'],
      id: doc.id,
      image: profileImage,
      name: place['name'],
      location:place['location'],
      description: place['description'],
      ambience: place['ambience'],
      capacity: place['capacity'],
      discounts: place['discounts'],
      address: address,
      reference: place.containsKey('manager_reference') ? place['manager_reference']: null,
      schedule: place.containsKey('schedule') ? place['schedule']: null,
      deals: place.containsKey('deals') ? place['deals']: null,
      types: place.containsKey('types') ? place['types'] : [],
      menu: place.containsKey('menu') ? place['menu']: null,
      hasOpenspace: place.containsKey('open_space') ? place['open_space']: null,
      hasReservations: place.containsKey('reservations') ? place['reservations']: null,
      isPartner: place.containsKey('partner') ? place['partner']: false,
      preferPhone: place.containsKey('prefer_phone') ? place['prefer_phone'] : null,
      phoneNumber: place.containsKey('phone_number') ? place['phone_number'] : null,
      tipMessage: place.containsKey('tip_message') ? place['tip_message'] : null,
    );
  }

  Future<Image> _getImage(String? placeId) async {
    var image = await FirebaseStorage.instance.ref("places/$placeId/0.jpg")
    .getData();
    return Image.memory(
      image!,
      fit: BoxFit.fill,
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



