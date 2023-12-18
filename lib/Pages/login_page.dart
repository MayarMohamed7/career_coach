
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:career_coach/Pages/signup_page.dart';
import 'package:career_coach/resources/auth_methods.dart';
import 'package:basic_utils/basic_utils.dart';
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
  
  void loginUser() async {
   

    try {
      String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (res == "success") {
        // Navigate to feed_screen.dart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
      showSnackbar(res, context);
      }
    } catch (e) {
      print("Login Error: $e");
      showSnackbar("An error occurred during login",context);
    } 

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
                              builder: (context) => signupPage()));
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
  onPressed: () {

      loginUser();
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