import 'package:career_coach/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatPage extends StatefulWidget{
  final String receiverUserEmail;
  final String receiverUserId;
  const chatPage({
  super.key, 
  required this.receiverUserEmail,
   required this.receiverUserId,
   });
  @override
  _chatPageState createState() => _chatPageState();
   
}
class _chatPageState extends State<chatPage>{
  final TextEditingController _messageController= TextEditingController();
  final ChatService chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  void sendMessage() async{
    //send message if there's data to sned
    String message = _messageController.text.trim();
    if( _messageController.text.isNotEmpty){
    await chatService.sendMessage(
      widget.receiverUserId, message);
      //clear message controller after message is sent
        _messageController.text = '';
      
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:Text(widget.receiverUserEmail)),
      body:Column(children: [
        Expanded(child: _buildMessageList(),
        )
      ],)
    );
   //build message list

   //build message item

   //build message input

  }
}