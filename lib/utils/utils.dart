import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<String> fetchCoachName(String coachId) async {
    DocumentSnapshot coachDoc = await FirebaseFirestore.instance
        .collection('coaches')
        .doc(coachId)
        .get();

    if (coachDoc.exists) {
      return coachDoc.get('firstName');
    } else {
      return 'Unknown'; // Handle this case as needed
    }
  }
}

void showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
