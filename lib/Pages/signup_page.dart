import 'package:flutter/material.dart';
import 'package:career_coach/Pages/login_page.dart';

import 'home.dart'; //signupPage

class signupPage extends StatelessWidget {
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
                decoration: InputDecoration(
                  labelText: 'Firstname',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Lastname',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff0f4f6c),
                ),
                child: Text('Sign up'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

