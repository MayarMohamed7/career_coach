import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';




class StorageMethods 
{
  final FirebaseStorage _storage = FirebaseStorage.instance; 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  //add image to firebase storage 
  Future<String> uploadImagetoStorage (String childName ,Uint8List image )async
  {
  Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
  ref.putData(image);
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

  }

 
