import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String loggedInUserId;

  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  late Stream<QuerySnapshot> _messagesStream;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    _messagesStream = _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        loggedInUserId = user.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  void sendMessage() async {
    if (messageTextController.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "sender": loggedInUserId,
        "message": messageTextController.text,
        "timestamp": DateTime.now()
      };

      _firestore.collection('messages').add(message);
      messageTextController.clear();
    }
  }

  void respond(String messageId) async {
    if (messageTextController.text.isNotEmpty) {
      Map<String, dynamic> response = {
        "sender": loggedInUserId,
        "message": messageTextController.text,
        "timestamp": DateTime.now(),
        "isResponse": true,
        "originalMessageId": messageId
      };

      _firestore.collection('messages').add(response);
      messageTextController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Color(0xFF0F4F6C), // Luxurious color
      ),
      body: StreamBuilder(
        stream: _messagesStream,
        builder: (context, snapshot) {
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];

              if (doc['sender'] == 'LdbimA6KumgDfbtONWFAL3ZSW433') {
                // Admin message
                return AdminMessageTile(message: doc['message']);
              } else {
                // User message
                return MessageTile(
                  message: doc['message'],
                  isMe: doc['sender'] == loggedInUserId,
                  onTap: () {
                    // Admin respond button tapped
                    respond(doc.id);
                  },
                );
              }
            },
          );
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white, // Background color
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageTextController,
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0F4F6C)), // Luxurious color
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0F4F6C)), // Luxurious color
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: sendMessage,
                child: Text(
                  'Send',
                  style: TextStyle(color: Color(0xFF0F4F6C)), // Luxurious color
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isMe;
  final VoidCallback onTap;

  const MessageTile({required this.message, required this.isMe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: isMe ? 0 : 24,
        right: isMe ? 24 : 0,
      ),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23),
            bottomLeft: isMe ? Radius.circular(23) : Radius.circular(0),
            topRight: Radius.circular(23),
            bottomRight: !isMe ? Radius.circular(23) : Radius.circular(0),
          ),
          color: isMe ? Colors.grey[300] : Colors.grey[300],
        ),
        child: Text(message),
      ),
    );
  }
}

class AdminMessageTile extends StatelessWidget {
  final String message;

  const AdminMessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23),
            bottomLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
          color: Color(0xFF0F4F6C), // Luxurious color
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white), // Contrast color
        ),
      ),
    );
  }
}
