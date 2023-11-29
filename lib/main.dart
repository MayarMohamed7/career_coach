import 'package:career_coach/screens/intro_page.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Coach',
      //redirecthomePage
      home: WelcomePage(),
    );
  }
}
