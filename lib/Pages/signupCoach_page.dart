import 'dart:typed_data';

import 'package:career_coach/Pages/profileCoach.dart';
import 'package:career_coach/resources/auth_methods.dart';
import 'package:career_coach/resources/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupPageCoach extends StatefulWidget {
  const SignupPageCoach({Key? key}) : super(key: key);

  @override
  _SignupPageCoachState createState() => _SignupPageCoachState();
}

class _SignupPageCoachState extends State<SignupPageCoach> {
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController=  TextEditingController() ; 
   final TextEditingController _firstnameController =TextEditingController();
  final TextEditingController _lastnameController =TextEditingController();
  final TextEditingController _yearsofExpController =TextEditingController();
  final TextEditingController _phoneController =TextEditingController();
   Uint8List?  _image ;
    final StorageMethods _storageMethods = StorageMethods(); 

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

  void selectImage(ImageSource source) async {
    Uint8List? image = await _storageMethods.pickImage(source);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/NiceJob.png',
              height: 120,
            ),
            SizedBox(width: 8),
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
                    SizedBox(height: 8),
                    Text(
                      'Please SignUp Here!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/3177/3177440.png'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 70,
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'camera') {
                            selectImage(ImageSource.camera);
                          } else if (value == 'gallery') {
                            selectImage(ImageSource.gallery);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'camera',
                            child: ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Camera'),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'gallery',
                            child: ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Gallery'),
                            ),
                          ),
                        ],
                        icon: Icon(Icons.add_a_photo),
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
                  controller: _lastnameController,
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
                ElevatedButton(
                   onPressed: () async {
    String? signUpResult = await AuthService().signUpCoachWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstnameController.text,
      lastName: _lastnameController.text,
      phoneNumber: _phoneController.text,
      yearsOfExperience: _yearsofExpController.text,
      profilePicture: _image!,
   

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
                    backgroundColor: Color(0xff0f4f6c),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}