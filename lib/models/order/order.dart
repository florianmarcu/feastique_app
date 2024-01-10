import 'package:feastique/models/models.dart';

class TableOrder{
  String id;
  Reservation reservation;
  List items;
  DateTime dateCreated;
  String details;
  bool? accepted;
  bool canceled;

  TableOrder({required this.id, required this.reservation, required this.items, required this.dateCreated, required this.details, required this.accepted, required this.canceled});
}

  TableOrder orderDataToOrder(Reservation reservation, String id,  Map<String, dynamic> data){
    return TableOrder(
      id: id, 
      reservation: reservation,
      items: data['items'],
      dateCreated: DateTime.fromMillisecondsSinceEpoch(data['date_created'].millisecondsSinceEpoch),
      details: data['details'],
      accepted: data['accepted'],
      canceled: data['canceled'] != true ? false : true
    );
  }