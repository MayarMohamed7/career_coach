import 'package:career_coach/Pages/login_page.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  const MyButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate font size based on screen width
    double fontSize = screenWidth * 0.05; // Adjust this multiplier as needed

    return GestureDetector(
      onTap: () {
        // Navigate to the login page when the button is pressed
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => loginPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Color(0xff0f4f6c),
                fontSize: fontSize,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward,
              color: Color(0xff0f4f6c),
            ),
          ],
        ),
      ),
    );
  }
}
