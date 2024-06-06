import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String name;
  final DateTime time;
  final String club;
  String status;
  final String? id;

  Event(
      {required this.name, required this.time, required this.club, required this.status, this.id});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        name: json['name'],
        time: (json['time']).toDate(),
        club: json['club'],
        status: json['status'],
        id: json['id']);
  }
  
  toJson() {
    return {
      'name': name,
      'club': club,
      'time': Timestamp.fromDate(time),
      'status': status,
      'id': id
    };
  }
}
