import 'package:flutter/material.dart';

class Session {
  Session({
    required this.name,
    required this.price,
    required this.date,
    required this.time,
    this.coachID,
    this.status,
  });

  final String name;
  final double price;
  final DateTime date;
  final TimeOfDay time;
  final String? coachID;
  final bool? status;
}
