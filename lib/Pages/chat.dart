import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<Widget> chatMessages = [];

  void sendMessage() {
    String message = messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        chatMessages.add(_buildMessage(
          sender: "User",
          message: message,
          isSender: true,
          imageUrl: "https://via.placeholder.com/50",
        ));
        // Simulating reply from the coach
        chatMessages.add(_buildMessage(
          sender: "Coach Name",
          message: "Received: $message",
          isSender: false,
          imageUrl: "https://via.placeholder.com/50",
        ));
        messageController.clear();
      });
    }
  }

  Widget _buildMessage({
    required String sender,
    required String message,
    required bool isSender,
    required String imageUrl,
  }) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sender,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            bottom: 60.0, // Space for the send message box
            child: ListView(
              children: <Widget>[
                // Existing chat messages
                ...chatMessages,
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration:
                          InputDecoration(hintText: "Send a message..."),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
