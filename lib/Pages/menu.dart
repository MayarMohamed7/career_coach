import 'package:career_coach/Pages/Reservation.dart';
import 'package:career_coach/Pages/profileUser.dart';
import 'package:flutter/material.dart';
import 'intro_page.dart';

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Details'),
      ),
      body: ListView(
        children: [
          // Create a container for each title with onTap to navigate
          buildTitleContainer(context, 'Account', () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfilePageUser()));
          }),
          buildTitleContainer(context, 'My Reservations', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReservationsPage()));
          }),
          buildTitleContainer(context, 'Sign Out', () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => WelcomePage()));
          }),
        ],
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
