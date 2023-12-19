import 'package:career_coach/Pages/Chat_messages.dart';
import 'package:career_coach/Pages/CoachesPage.dart';
import 'package:career_coach/Pages/SessionPage.dart';
import 'package:career_coach/Pages/chat.dart';
import 'package:career_coach/Pages/intro_page.dart';
import 'package:career_coach/Pages/newSession.dart';
import 'package:career_coach/Pages/new_message.dart';
import 'package:career_coach/Pages/signupCoach_page.dart';
import 'package:flutter/material.dart';
import 'package:career_coach/Pages/profileUser.dart';
import 'package:career_coach/Pages/signupUser_page.dart';
import 'package:career_coach/Pages/login_page.dart';
import 'package:career_coach/Pages/choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:career_coach/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
