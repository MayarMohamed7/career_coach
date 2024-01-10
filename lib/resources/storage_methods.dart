import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class StorageMethods 
{
  final FirebaseStorage _storage = FirebaseStorage.instance; 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  //add image to firebase storage 
 Future<String> uploadImagetoStorage(String childName, Uint8List image) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
}

  Future<bool> _checkCameraPermission() async {
  PermissionStatus permission = await Permission.camera.status;
  if (permission != PermissionStatus.granted) {
    PermissionStatus permissionStatus = await Permission.camera.request();
    return permissionStatus == PermissionStatus.granted;
  } else {
    return true;
  }
}

  

  Future<Uint8List?> pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      // Check for camera permission
      bool hasPermission = await _checkCameraPermission();
      if (!hasPermission) {
        // Handle case when permission is not granted
        return null;
      }
    
    }
 

  final pickedFile = await _picker.pickImage(source: source);
  if (pickedFile != null) {
    return await pickedFile.readAsBytes();
  }
  return null;
}
Future<String?> getProfileImg(String userId) async {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  try {
    // Create a reference to the profile image in Firebase Storage
    Reference ref = _storage.ref().child('profile_images').child('$userId.jpg');

    // Get the download URL of the profile image
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Error retrieving profile image: $e');
    return null;
  }
}
 Future<String> retrieveProfileImage(String userId) async {
  // Get the document for the user from Firestore
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

  // Get the profileImage field from the document
  String? profileImageURL = (userDoc.data() as Map<String, dynamic>)?['profilePicture'];

  // If the profileImage field exists, return it
  if (profileImageURL != null) {
    return profileImageURL;
  } else {
    // If the profileImage field doesn't exist, return a default image URL
    return   'https://cdn-icons-png.flaticon.com/512/3177/3177440.png' ; 
  }
}
  
  //methods for rating coach 
   Future<void> rateCoach(String coachId, double rating) async {
    try {
      // Save rating to Firestore 'ratings' collection
      await _firestore.collection('ratings').doc(coachId).set({
        'userId': _auth.currentUser!.uid,
        'coachId': coachId,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error rating coach: $e');
    }
  }
  Future<void> showRatingDialog(BuildContext context, String coachId) async {
    double _userRating = 0;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate Coach'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
         
            RatingBar.builder(
              initialRating: _userRating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                }
              },
              onRatingUpdate: (rating) {
                _userRating = rating;
                print("Rating: $_userRating");
              },
            ),

              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    await rateCoach(coachId, _userRating); // Save rating
                    Navigator.of(context).pop(); // Close dialog on button press
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

  

 
