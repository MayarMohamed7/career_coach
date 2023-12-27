import 'package:flutter/material.dart';
import 'package:career_coach/components/buttons.dart';
import 'package:career_coach/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bb.png'), 
                fit: BoxFit.cover, 
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Icon
                Center(
                  child: Image.asset(
                    'assets/images/NiceJob.png',
                    width: 300,
                    height: 300,
                  ),
                ),
                // Description
                const Text(
                  "Choose Your Suitable Career Path",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 2,
                    color:  Color.fromRGBO(245, 219, 48, 1),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Nowadays choosing a career isn't difficult that much, We Are Here To Help You !",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 1),
                    height: 2,
                  ),
                ),
                const SizedBox(height: 25),
                const MyButton(text: "Get Started"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
