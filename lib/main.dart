import 'package:flutter/material.dart';
import 'package:career_coach/screens/login_page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Coach',
      home: loginPage(),
    );
  }
}
