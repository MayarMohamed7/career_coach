import 'package:career_coach/Pages/intro_page.dart';
import 'package:career_coach/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
     ProviderScope(   
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _initializeFirebaseMessaging(); // Initialize Firebase Messaging

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, 
      home: const WelcomePage(),
    );
  }

  void _initializeFirebaseMessaging() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: $message');
      // Handle incoming messages when the app is in the foreground
      // You can use this data to display a notification to the user or handle other tasks
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('User tapped on the notification when the app was in the background!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      // Handle notifications that were tapped when the app was in the background
    });
  }
}