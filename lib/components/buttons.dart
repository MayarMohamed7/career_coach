import 'package:flutter/material.dart';
import 'package:career_coach/Pages/choice.dart';

class MyButton extends StatelessWidget {
  final String text;
  const MyButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.04;

    return GestureDetector(
      onTap: () {
        // Navigate to the choice page when the button is pressed
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChoicePage()),
        );
      },
      child: Center( // Wrap the MyButton widget with Center
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Color(0xff0f4f6c),
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
