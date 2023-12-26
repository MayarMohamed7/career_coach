import 'package:career_coach/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get currentUserId => firebaseAuth.currentUser!.uid;
  String get currentUserEmail => firebaseAuth.currentUser!.email.toString();
  final Timestamp timestamp = Timestamp.now();

  Future<bool> sendMessage(String receiverId, String message) async {
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatId = ids.join(" - ");
    try {
      await firestore.collection('messages').doc(chatId).collection(chatId).add(newMessage.toMap());
      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatId = ids.join(" - ");
    return firestore
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
