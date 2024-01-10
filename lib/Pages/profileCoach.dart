import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:career_coach/Pages/profileUser.dart';
import 'package:career_coach/Pages/login_page.dart';
import 'package:career_coach/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'menu.dart';
class ProfilePageCoach extends StatefulWidget {

   const ProfilePageCoach({super.key}) ; 
  @override
  _ProfilePageCoachState createState() => _ProfilePageCoachState();
}
class _ProfilePageCoachState extends State<ProfilePageCoach> {
    final StorageMethods _storageMethods = StorageMethods();
     TextEditingController _aboutController = TextEditingController();
    TextEditingController _linkController = TextEditingController();
      String aboutText = '';
      String linkText = '';
      String userUid = '';
User? user ;
    
    
  bool isEditingAbout = false;
  bool isEditingLink = false;
 var userData={};   

  @override
      void initState() {
        super.initState();
     user = FirebaseAuth.instance.currentUser;
       
    _aboutController.text = aboutText;
    _linkController.text = linkText;
    getData();
    getAboutText();
     getLinkText();
     
      }
  getAboutText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      aboutText = prefs.getString('aboutText') ?? '';
      _aboutController.text = aboutText;
    });
  }
  getLinkText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      linkText = prefs.getString('linkText') ?? '';
      _linkController.text = linkText;
    });
  }

  saveAboutText(String newText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('aboutText', newText);
  }
  saveLinkText(String newText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('linkText', newText);
  } 
  
  getData() async {
    try{
var  snap  =await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
userData = snap.data()!; 
setState(() {
});

    }
    catch(e){
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.red,));
    }
  }
    final double coverHeight = 280;
  final double profileHeight = 144;
String? _Profileimage;

   

  void updateAboutText(String newText) {
    setState(() {
      aboutText = newText;
      saveAboutText(newText);
    });
    
  }
  void updateLinkText(String newText) {
    setState(() {
      linkText = newText;
      saveLinkText(newText);
    });
    
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/NiceJob.png',
              height: 120,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          buildProfileImage(),
          SizedBox(height: 10),
          Text(
            '${userData['firstName']} ${userData['lastName']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          SizedBox(height: 20),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildProfileImage() {
  String? profilePicture = userData['profilePicture'];
  return CircleAvatar(
    radius: 64,
    backgroundColor: Colors.grey, // Set a background color while loading
    child: profilePicture != null && profilePicture.isNotEmpty
        ? ClipOval(
            child: Image.network(
              profilePicture,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                // Error handling for loading the image
                print('Error loading profile image: $exception');
                return Center(
                  child: Text(
                    'Failed to load image',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child; // If no progress, return the loaded image
                } else {
                  return Center(
                    child: CircularProgressIndicator(), // Show a loading indicator while image is loading
                  );
                }
              },
            ),
          )
        : Image.network(
            'https://cdn-icons-png.flaticon.com/512/3177/3177440.png',
          ),
  );
}

 Widget buildContent() {
  return Column(
    children: [
      SizedBox(height: 8),
     /* Text(
        '${userData['firstName']} ${userData['lastName']}',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
      ),
      SizedBox(height: 16),*/
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.infoCircle, size: 28),
                SizedBox(width: 8),
                Text(
                  'Contact Info',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(FontAwesomeIcons.phoneVolume, size: 17),
                SizedBox(width: 4),
                Text(
                  'Phone Number: ${userData['phoneNumber'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(FontAwesomeIcons.link, size: 17),
                SizedBox(width: 4),
                Text(
                  'Links:',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal),
                ),
                IconButton(
                  icon: Icon(isEditingLink ? Icons.done : Icons.edit),
                  onPressed: () {
                    setState(() {
                      if (isEditingLink) {
                        updateLinkText(_linkController.text);
                      }
                      isEditingLink = !isEditingLink;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            isEditingLink
                ? TextField(
                    controller: _linkController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Edit Links',
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    linkText,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'About',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(isEditingAbout ? Icons.done : Icons.edit),
                  onPressed: () {
                    setState(() {
                      if (isEditingAbout) {
                        updateAboutText(_aboutController.text);
                      }
                      isEditingAbout = !isEditingAbout;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            isEditingAbout
                ? TextField(
                    controller: _aboutController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Edit About',
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    aboutText,
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