import 'package:career_coach/Pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods
{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//for sign up new user 
   Future <String>  signupUser ({
    required String email,
      required String password , 
      required String Firstname ,
       required String Lastname}) async
  {
  String res = 'some error occured'; 
  try{
    if(email.isNotEmpty || password.isNotEmpty || Firstname.isNotEmpty || Lastname.isNotEmpty)
    {
    UserCredential cred =   await _auth.createUserWithEmailAndPassword(email: email, password: password);
    print(cred.user!.uid);
    //add user to our database 
     await _firestore.collection('users').add({ 
      'email': email,
      'uid': cred.user!.uid,
      'password': password,
      'Firstname': Firstname,
      'Lastname': Lastname,
    });
    //
res= 'success'; 
    }
    else
    {
      res = 'please enter all the fields';
    }

  } catch(err)
  {
res = err.toString();
  }
return res;
  }

  // for login user
 Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = "Error: ${err.toString()}";
    }
    return res;
  }

//signing out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
