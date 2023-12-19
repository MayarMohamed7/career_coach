import 'package:flutter/material.dart';
import 'package:career_coach/Pages/login_page.dart';
import 'package:career_coach/resources/auth_methods.dart';
import 'package:career_coach/Pages/profileUser.dart';
// Other necessary imports

class SignupPageUser extends StatefulWidget {
  const SignupPageUser({Key? key}) : super(key: key);

  @override
  _SignupPageUserState createState() => _SignupPageUserState();
}

class _SignupPageUserState extends State<SignupPageUser> {
  

  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController=  TextEditingController() ; 
   final TextEditingController _firstnameController =TextEditingController();
  final TextEditingController _lastnameController =TextEditingController();

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
          child: SingleChildScrollView(
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
    String? signUpResult = await AuthService(). signUpUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstnameController.text,
      lastName: _lastnameController.text,
      phoneNumber: _phoneController.text,
 
      
    );

    // Check the signup result and perform actions accordingly
    if (signUpResult == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePageUser()),
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