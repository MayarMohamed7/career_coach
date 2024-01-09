import 'dart:typed_data';
import 'package:career_coach/Pages/home.dart';
import 'package:flutter/material.dart';
import 'package:career_coach/Pages/login_page.dart';
import 'package:career_coach/resources/auth_methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:career_coach/resources/storage_methods.dart';
// Other necessary imports

class SignupPageUser extends StatefulWidget {
  const SignupPageUser({super.key});

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
    bool _isLoading = false;

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
          backgroundColor: const Color(0xff0f4f6c),
          title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/NiceJob.png',
              height: 120,
            ),
            const SizedBox(width: 8),
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
                const Row(
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
                const SizedBox(height: 10),
                //circular widget to add selected image : 
         
                Stack(
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
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
                  const PopupMenuItem<String>(
                    value: 'camera',
                    child: ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Camera'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'gallery',
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  ),
                ],
                icon: const Icon(Icons.add_a_photo),
              ),
            ),
          ],
        ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _firstnameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Firstname',
                    labelText: 'Firstname',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Lastname',
                    labelText: 'Lastname',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Phone Number',
                    labelText: 'Phone Number',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already have an account?'),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const loginPage()),
                        );
                      },
                      child: const Text(
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
                const SizedBox(height: 20),
                ElevatedButton(
                      onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    }); 
                    String? signUpResult =
                        await AuthService().signUpUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                      firstName: _firstnameController.text,
                      lastName: _lastnameController.text,
                      phoneNumber: _phoneController.text,
                      profilePicture: _image, 
             



                    );
                    
   setState(() {
                      _isLoading = false;
                    });
                    // Check the signup result and perform actions accordingly
                    if (signUpResult == null) {
                    
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  HomePage()),
                      );
                    } else {
                      // Signup failed, show an error message or handle the error
                      print("Signup failed: $signUpResult");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(signUpResult),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 5), 
                        ),
                      );
                    }
                  }, // Show "Sign Up" text otherwise
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0f4f6c),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                 child: _isLoading
                      ? const CircularProgressIndicator() // Show progress indicator when loading
                      : const Text('Sign Up'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}