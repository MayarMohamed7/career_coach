
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:career_coach/Pages/signupUser_page.dart';
import 'package:career_coach/Pages/signupCoach_page.dart';
import 'package:career_coach/resources/auth_methods.dart';
import 'package:career_coach/utils/utils.dart';

import 'home.dart';


//loginPage

final _firebase= FirebaseAuth.instance;
class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController=  TextEditingController() ; 
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
        title: Text('Career Compass'),
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
              Text(
                'Career Compass',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
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
  onPressed: () async{

        String? signInResult = await AuthService().signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (signInResult == null) {
      // Sign-in successful, navigate to the home page or perform actions
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Sign-in failed, show an error message or handle the error
      print("Sign-in failed: $signInResult");
      
      // Show an error message using ScaffoldMessenger's snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign-in failed: $signInResult"),
          duration: Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
    }
  },

 
  child: Text('Login'),
  style: ElevatedButton.styleFrom(
    primary: Color(0xff0f4f6c), 
    onPrimary: Colors.white, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0), 
    ),
  )

), 
  
            ],
          ),
        ),
      ),
    );                            

  }
 
}