import 'package:flutter/material.dart';
import 'details.dart';
import 'menu.dart';
import 'signup_page.dart';
import 'home.dart';

//loginPage

class loginPage extends StatelessWidget {
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
                  labelText: 'Username',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff0f4f6c),
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}