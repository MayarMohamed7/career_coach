import 'package:career_coach/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class  passwordResetpage extends StatefulWidget
{
  const passwordResetpage({super.key}); 

  @override
  _passwordResetState  createState() => _passwordResetState();
}
class _passwordResetState extends State<passwordResetpage>
{
  final formkey = GlobalKey<FormState>(); 
  final emailController = TextEditingController();
   @override
   void dispose ()
   {
    emailController.dispose();
    super.dispose();
   }
  Future resetpassword() async
  {
 
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('password Reset Email Sent'),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.green,));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const loginPage()), // Replace with your Login Page
      );
      return true;
    } on FirebaseAuthException catch(e)
    {
  
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,));
    
      return false;
     
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
          child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          const Text(
            'Recieve a password reset link',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailController,
                textInputAction: TextInputAction.done,
                cursorColor: Colors.grey,
                keyboardType: TextInputType.emailAddress,


            decoration: const InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
          

            ),
            
            
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 5, 41, 71),
              minimumSize: const Size.fromHeight(50),
            )

          , icon: const Icon(Icons.email), label: const Text('Send Email' , style: TextStyle(fontSize: 24),),
           onPressed: () {
            resetpassword();
           },
          ),
         ],
          ),
        ),
    );
    
        
  }
}