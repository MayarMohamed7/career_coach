import 'package:career_coach/Pages/CoachesPage.dart';
import 'package:career_coach/Pages/Reservation.dart';
import 'package:career_coach/Pages/intro_page.dart';
import 'package:career_coach/Pages/profileUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; 

class DetailsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Details'),
      ),
      body: ListView(
        children: [
          buildTitleContainer(context, 'Account', () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ProfilePageUser()));
          }),
          buildTitleContainer(context, 'My Reservations', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationsPage()));
          }),
          buildTitleContainer(context, 'Coaches', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CoachesPage()));
          }),
          buildTitleContainer(context, 'Sign Out', () {
            _auth.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomePage()));
          }),
        ],
      ),
    );
  }

  Widget buildTitleContainer(BuildContext context, String title, VoidCallback onTapFunction) {
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
