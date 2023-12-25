import 'package:compass_icon/compass_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'menu.dart'; // Importing the font_awesome_flutter package

class ProfilePageUser extends StatefulWidget {
  @override
  _ProfilePageUserState createState() => _ProfilePageUserState();
}

class _ProfilePageUserState extends State<ProfilePageUser> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff0f4f6c),
          title: Row(
            children: [
              CompassIcon(
                Icon(Icons.compass_calibration_rounded, size: 24),
                compassDirection: CompassDirection.north,
                initialDirection: CompassDirection.southWest,
              ),
              SizedBox(height: 8),
              Text('Career Compass', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: ListView(
        children: [
          buildTop(),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      child: Image.asset('assets/images/careercompass.png',
           height: coverHeight,
        fit: BoxFit.cover,) ,
   
      
    );
  }

  Widget buildProfileImage() {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/3177/3177440.png'),
    );
  }

  Widget buildContent() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'John Doe',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        Text(
          'Flutter Software Developer',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSocialIcon(FontAwesomeIcons
                .github), // Using the correct prefix for FontAwesomeIcons
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons
                .slack), // Using the correct prefix for FontAwesomeIcons
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons
                .linkedin), // Using the correct prefix for FontAwesomeIcons
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'about',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                'flutter Software Developer with 2 years of experience in mobile application development. Skilled in AndroidFlutter, Firebase, Java, Kotlin, and Dart. Strong engineering professional with a Bachelor of Technology BTech focused in Computer Science from Lovely Professional University.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSocialIcon(IconData icon) {
    return CircleAvatar(
      radius: 25,
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Center(
            child: Icon(
              icon,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

