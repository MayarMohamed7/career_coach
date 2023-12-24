import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Session {
  Session({
    required this.id,
    required this.price,
    required this.date,
    required this.time,
    required this.coachId,
    required this.status,
  });

  final String id;
  final String price;
  final DateTime date;
  final TimeOfDay time;
  final String coachId;
  final String status;

  factory Session.fromMap(Map<String, dynamic> map, String id) {
    //when using dynamic you are telling dart that the value could be of any type
    int totalMinutes = map['time'];
    TimeOfDay time =
        TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);

    return Session(
      id: id,
      price: map['price'],
      date: (map['date'] as Timestamp).toDate(),
      time: time,
      coachId: map['coachId'],
      status: map['status'],
    );
  }
}
