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

      // Add response message to collection
      _firestore.collection('messages').add(response);

      messageTextController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder(
          stream: _messagesStream,
          builder: (context, snapshot) {
            return ListView.builder(
                reverse: false,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];

                  if (doc['sender'] == 'LdbimA6KumgDfbtONWFAL3ZSW433') {
                    // Admin message
                    return AdminMessageTile(
                      message: doc['message'],
                    );
                  } else {
                    // User message
                    return MessageTile(
                        message: doc['message'],
                        isMe: doc['sender'] == loggedInUserId,
                        onTap: () {
                          // Admin respond button tapped
                          respond(doc.id);
                        });
                  }
                });
          }),
      bottomSheet: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageTextController,
              decoration: InputDecoration(
                hintText: 'Message...',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red), // Set the border color here
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: sendMessage,
            child: Text('Send'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
          )
        ],
      ),
    );
  }
}

// Message tiles
// Message tile
class MessageTile extends StatelessWidget {
  final String message;
  final bool isMe;
  final VoidCallback onTap;

  const MessageTile(
      {required this.message, required this.isMe, required this.onTap});

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: isMe ? 0 : 24, right: isMe ? 24 : 0),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                  topRight: Radius.circular(23))
              : BorderRadius.only(
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                  topLeft: Radius.circular(23)),
          color: isMe ? Colors.grey[300] : Colors.grey[300],
        ),
        child: Text(message),
      ),
    );
  }
}

// Admin message tile
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
          color: Colors.red[300],
        ),
        child: Text(message),
      ),
    );
  }
}