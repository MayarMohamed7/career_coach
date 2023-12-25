import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:career_coach/Pages/login_page.dart';
import 'package:career_coach/resources/auth_methods.dart';
import 'package:career_coach/Pages/profileUser.dart';
import 'package:compass_icon/compass_icon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:career_coach/utils/utils.dart';
import 'package:career_coach/resources/storage_methods.dart';
// Other necessary imports

class SignupPageUser extends StatefulWidget {
  const SignupPageUser({Key? key}) : super(key: key);

  @override
  _SignupPageUserState createState() => _SignupPageUserState();
}

class _SignupPageUserState extends State<SignupPageUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
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
                //circular widget to add selected image : 
         
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
                    // Use ImageSource.camera directly
                  } else if (value == 'gallery') {
                    selectImage(ImageSource.gallery);
                    
                     // Use ImageSource.gallery directly
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                    String? signUpResult =
                        await AuthService().signUpUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                      firstName: _firstnameController.text,
                      lastName: _lastnameController.text,
                      phoneNumber: _phoneController.text,
                      profilePicture: _image!, 
             



                    );

                    // Check the signup result and perform actions accordingly
                    if (signUpResult == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePageUser()),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
