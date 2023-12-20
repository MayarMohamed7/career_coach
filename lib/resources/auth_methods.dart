import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//auth methods ////
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<String?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
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
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
        });

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
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's UID
      String? uid = userCredential.user?.uid;

      if (uid != null) {
        // Save user data to Firestore in the 'coaches' collection
        await _firestore.collection('users').doc(uid).set({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
        });

        return null; // Return null if signup is successful
      } else {
        return 'Failed to create user'; // Return error if UID is null
      }
    } catch (e) {
      return e.toString(); // Return the error message if signup fails
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    try {
      // Check if the user exists in the 'users' collection based on email
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  Future<bool> checkIfCoachExists(String email) async {
    try {
      // Check if the user exists in the 'coaches' collection based on email
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
    await _auth.signOut();
  }
}
