import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation{
  
  String id;
  bool? accepted;
  DateTime dateCreated;
  DateTime dateStart;
  String guestId;
  String guestName;
  String placeId;
  String placeName;
  String contactPhoneNumber;
  String contactName;
  String details;
  bool? claimed;
  bool? active;
  bool canceled;
  int peopleNo;
  Map<String, dynamic>? deals;
  Map<String, dynamic>? discounts;
  int? discount;

  DocumentReference? placeReservationRef;
  DocumentReference? userReservationRef;

  Reservation(
    {
      required this.id,
      required this.accepted,
      required this.dateCreated,
      required this.dateStart,
      required this.guestId,
      required this.guestName,
      required this.placeId,
      required this.placeName,
      required this.contactPhoneNumber,
      required this.contactName,
      required this.details,
      required this.claimed,
      required this.active,
      required this.canceled,
      required this.peopleNo,
      required this.deals,
      required this.discounts,
      required this.discount,
      required this.placeReservationRef,
      required this.userReservationRef
    }
  );
}

Reservation reservationDataToReservation(String id, Map<String, dynamic> data){
  return Reservation(
    id: id,
    accepted: data['accepted'],
    dateCreated: data['date_created'].runtimeType == Timestamp ? DateTime.fromMillisecondsSinceEpoch(data['date_created'].millisecondsSinceEpoch) : data['date_created'],
    dateStart: DateTime.fromMillisecondsSinceEpoch(data['date_start'].millisecondsSinceEpoch),
    guestId: data['guest_id'],
    guestName: data['guest_name'],
    placeId: data['place_id'],
    placeName: data['place_name'],
    contactPhoneNumber: data['contact_phone_number'],
    contactName: data['contact_name'],
    details: data['details'],
    claimed: data['claimed'],
    active: data['active'],
    canceled: data['canceled'] == true ? true : false,
    peopleNo: data['number_of_guests'],
    discounts: data['discounts'],
    discount: data['discount'],
    deals: data['deals'],
    placeReservationRef: data['place_reservation_ref'],
    userReservationRef: data['user_reservation_ref']
  );
}