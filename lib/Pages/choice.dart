import 'package:flutter/material.dart';
import 'package:career_coach/Pages/signupUser_page.dart'; 
import 'package:career_coach/Pages/signupCoach_page.dart';
import 'package:career_coach/firebase_options.dart';



class choicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
      
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Career Compass'),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPageUser()),
                    );
                  },
                  child: Text('User'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, double.infinity),
                    primary: Color(0xff0f4f6c),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                         
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              SizedBox(height: 20), // Adding space between buttons
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPageCoach()));  
                  },
                    
                
                  child: Text('Coach'),
              
                  style: ElevatedButton.styleFrom(
                           fixedSize: Size(300, double.infinity),
                    primary: Color(0xff0f4f6c),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
