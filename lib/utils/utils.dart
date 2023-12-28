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
      return 'Unknown';
    }
  }

  static Future<String> fetchUserName(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      return userDoc.get('firstName');
    } else {
      return 'Unknown';
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
