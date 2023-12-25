import 'package:flutter/material.dart';
import 'package:career_coach/Pages/login_page.dart';
import 'package:career_coach/resources/auth_methods.dart';
import'package:career_coach/firebase_options.dart';
import 'package:career_coach/Pages/profileCoach.dart'; 
import 'package:compass_icon/compass_icon.dart';

class SignupPageCoach extends StatefulWidget {
const SignupPageCoach({Key? key}) : super(key: key);
_SignupPageCoachState createState() => _SignupPageCoachState();
}
class _SignupPageCoachState extends State<SignupPageCoach> {
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController=  TextEditingController() ; 
   final TextEditingController _firstnameController =TextEditingController();
  final TextEditingController _lastnameController =TextEditingController();
  final TextEditingController _yearsofExpController =TextEditingController();
  final TextEditingController _phoneController =TextEditingController();

   //bool _isLoading = false;
    
  
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _yearsofExpController.dispose();
    
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: SingleChildScrollView(
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
                TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _firstnameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Firstname',
                    labelText: 'Firstname',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _lastnameController ,
                  decoration: InputDecoration(
                    hintText: 'Enter your Lastname',
                    labelText: 'Lastname',
                  ),
                ),
                 SizedBox(height: 10),
                TextFormField(
                    
                  keyboardType: TextInputType.number,
                  controller: _yearsofExpController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Years of Experience',
                    labelText: 'Years of Experience',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Phone Number',
                    labelText: 'Phone Number',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already have an account?'),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => loginPage()),
                        );
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
                SizedBox(height: 20),
                ElevatedButton(
                   onPressed: () async {
    String? signUpResult = await AuthService().signUpCoachWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstnameController.text,
      lastName: _lastnameController.text,
      phoneNumber: _phoneController.text,
      yearsOfExperience: _yearsofExpController.text,
   

    );

    // Check the signup result and perform actions accordingly
    if (signUpResult == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePageCoach()),
      );
    } else {
      // Signup failed, show an error message or handle the error
      print("Signup failed: $signUpResult");
    }
  },
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
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
      ),
    );
  }
}
