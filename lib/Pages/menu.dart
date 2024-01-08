import 'package:career_coach/Pages/CoachesPage.dart';
import 'package:career_coach/Pages/Reservation.dart';
import 'package:career_coach/Pages/intro_page.dart';
import 'package:career_coach/Pages/profileUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _iconBool = false;
  IconData _iconLight = Icons.wb_sunny;
  IconData _iconDark = Icons.nights_stay;
  ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.amber,
    brightness: Brightness.light,
  );
  ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _iconBool ? _darkTheme : _lightTheme,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0f4f6c),
          title: Text('Details'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _iconBool = !_iconBool;
                });
              },
              icon: Icon(_iconBool ? _iconDark : _iconLight),
            )
          ],
        ),
        body: ListView(
          children: [
            buildTitleContainer(context, 'My Reservations', ( ) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReservationsPage()));
            }),
            buildTitleContainer(context, 'Coaches', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoachesPage()));
            }),
            buildTitleContainer(context, 'Sign Out', () {
              _auth.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomePage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget buildTitleContainer(
      BuildContext context, String title, VoidCallback onTapFunction) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
