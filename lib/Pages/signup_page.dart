import 'package:flutter/material.dart';
import 'package:career_coach/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:career_coach/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:career_coach/resources/auth_methods.dart';

import 'home.dart'; //signupPage

class signupPage extends StatefulWidget {
  const signupPage({Key? key}) : super(key: key);
  @override
  _signupPageState createState() => _signupPageState();
}
class _signupPageState extends State<signupPage> {

  final TextEditingController _firstNameController = TextEditingController();
 final TextEditingController _lastNameController = TextEditingController() ;
 final TextEditingController _phoneNumberController = TextEditingController() ;
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController=  TextEditingController() ; 
  
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Career Compass'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
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
              
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your Firstname', 
                  labelText: 'Firstname',
    
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your Lastname',
                  labelText: 'Lastname',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  hintText: 'Enter your Phone Number',
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(height: 10),
              TextField(
             
                controller: _emailController,
                decoration: InputDecoration(
              hintText:'Enter your Email',
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your Password',
                  labelText: 'Password',
                ),
              ),
             
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('already have an account?'),
                  SizedBox(width: 10),
                  GestureDetector(
                    
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => loginPage()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xff0f4f6c),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          InkWell(
  onTap: () async {
    String res = await AuthMethods().signupUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      Firstname: _firstNameController.text.trim(),
      Lastname: _lastNameController.text.trim(),
    );
    print(res);
     if (res == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
  }
  }, 

  child: Container(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    decoration: BoxDecoration(
      color: Color(0xff0f4f6c),
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: Text(
      'Sign up',
      style: TextStyle(color: Colors.white),
    ),
  ),
),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

  