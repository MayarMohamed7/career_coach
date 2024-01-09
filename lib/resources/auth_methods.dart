import 'dart:html';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:career_coach/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//auth methods
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<String?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
        SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);

      return null; // Return null if login is successful
    } catch (e) {
      return e.toString(); // Return the error message if login fails
    }
  }

  // Sign up with email and password

  Future<String?> signUpCoachWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String yearsOfExperience,
   Uint8List? profilePicture,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(profilePicture != null)  { StorageMethods().uploadImagetoStorage('coachprofileimg', profilePicture ); }

      // Get the user's UID
      String? uid = userCredential.user?.uid;

      if (uid != null) {
        // Save user data to Firestore in the 'coaches' collection
        await _firestore.collection('coaches').doc(uid).set({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'password': password,
          'yearsOfExperience': yearsOfExperience,
             'profilePicture': profilePicture,
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedIn', true);    

        return null; // Return null if signup is successful
      } else {
        return 'Failed to create user'; // Return error if UID is null
      }
    } catch (e) {
      return e.toString(); // Return the error message if signup fails
    }
  }

  Future<String?> signUpUserWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    Uint8List?   profilePicture,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ); if(profilePicture != null) 
       { StorageMethods().uploadImagetoStorage('userprofileimg', profilePicture ); }
      // Get the user's UID
      String? uid = userCredential.user?.uid;

      if (uid != null) {
        // Save user data to Firestore in the 'coaches' collection
        await _firestore.collection('users').doc(uid).set({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'password': password,
          'profilePicture': profilePicture,
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedIn', true);    

        return null; // Return null if signup is successful
      } else {
        return 'Failed to create user'; // Return error if UID is null
      }
    } catch (e) {
      return e.toString(); // Return the error message if signup fails
    }
  }
// check if user exists
// bycheck lw el user mawgod abl kda wla la
  Future<bool> checkIfUserExists(String email) async {
    try {
      // Check if the user exists in the 'users' collection based on email
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
          

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Return false if there is an error
      print('Error checking user existence: $e');
      return false;

    }
  }
// check if coach exists
// bycheck lw el coach mawgod abl kda wla la
  Future<bool> checkIfCoachExists(String email) async {
    try {
     /*QuerySnapshot is a class in th
     e Firebase Firestore library for Dart/Flutter.
      It represents the results of a query. 
     When you perform a query against a Firestore database,
      the result is a QuerySnapshot object.
In the provided code, QuerySnapshot is used to hold the result
 of a query that checks if a coach with 
    a specific email exists in the 'coaches' collection of the Firestore database. */
      QuerySnapshot querySnapshot = await _firestore
          .collection('coaches')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking coach existence: $e');
      return false;
    }
  }

 // Sign out
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);

  }


  Future<bool> checkAuthenticationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('loggedIn') ?? false;
    return loggedIn;
  }
}

