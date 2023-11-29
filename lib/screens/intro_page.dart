import 'package:career_coach/components/buttons.dart';
import 'package:flutter/material.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2e31cb),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Web name
            Text(
              "Welcome To Your Career Coach ",
              style: TextStyle(
                fontFamily: ('Roboto'),
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            MyButton(text: "Get Started"),
            //icon
            Image.asset('lib/images/icon.png'),
            // Description
            Text(
              "Choose Your Suitable Career Path",
              style: TextStyle(
                fontFamily: ('Roboto'),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 2,
                color: Color(0xff191404),
              ),
            ),
            const SizedBox(height: 10),
            Text(
                "Nowadays choosing a career isn't difficult that much, We Are Here To Help You !",
                style: TextStyle(
                  color: Colors.grey,
                  height: 2,
                )),
            const SizedBox(height: 15),
            MyButton(text: "Get Started"),
          ],
        ),
      ),
    );
  }
}
