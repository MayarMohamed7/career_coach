import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: Image.network(
        'https://www.forbes.com/advisor/wp-content/uploads/2023/02/Fastest_Growing_Jobs.jpeg.jpg',
        height: coverHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProfileImage() {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: NetworkImage(
          'https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-PNG-File.png'),
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
            buildSocialIcon(FontAwesomeIcons.github),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.slack),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.linkedin),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 48)  ,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('about',style: TextStyle(fontSize: 28,fontWeight:FontWeight.w600),),
              const SizedBox(height: 16),
              Text('flutter Software Developer with 2 years of experience in mob ile application development. Skilled in AndroidFlutter, Firebase, Java, Kotlin, and Dart. Strong engineering professional with a Bachelor of Technology BTech focused in Computer Science from Lovely Professional University.'
              ,style: TextStyle(fontSize: 20,fontWeight:FontWeight.w400),),
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
