import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:career_coach/Pages/signupUser_page.dart';
import 'package:career_coach/Pages/signupCoach_page.dart';
import 'package:career_coach/resources/auth_methods.dart';
import 'package:career_coach/utils/utils.dart';
import 'package:career_coach/Pages/newSession.dart';
import 'package:compass_icon/compass_icon.dart';

import 'home.dart';

//loginPage

final _firebase = FirebaseAuth.instance;

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
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
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                       CompassIcon(
                    Icon(Icons.compass_calibration_rounded, size: 24),
                    compassDirection: CompassDirection.north,
                    initialDirection: CompassDirection.southWest,
                                  ),
                                  SizedBox(height: 8),
                    Text(
                      'Career Compass',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                  
                  ],
                ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'enter your email',
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'enter your password',
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Don\'t have an account?'),
                  SizedBox(width: 25),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPageUser()));
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color(0xff0f4f6c),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    String? signInResult =
                        await AuthService().signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    if (signInResult == null) {
                      // Check if the user exists in the 'users' collection
                      bool isUser = await AuthService()
                          .checkIfUserExists(_emailController.text);

                      // Check if the user exists in the 'coaches' collection
                      bool isCoach = await AuthService()
                          .checkIfCoachExists(_emailController.text);

                      if (isUser) {
                        // Redirect to home page if the user exists in the 'users' collection
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else if (isCoach) {
                        // Redirect to the new session page if the user exists in the 'coaches' collection
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewSession()),
                        );
                      } else {
                        // Handle scenario where the user is neither in 'users' nor 'coaches'
                        print('User not found in either table');
                      }
                    } else {
                      // Sign-in failed, show an error message or handle the error
                      print("Sign-in failed: $signInResult");

                      // Show an error message using ScaffoldMessenger's snackbar with duration of 3 seconds
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Sign-in failed: $signInResult"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0f4f6c),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
