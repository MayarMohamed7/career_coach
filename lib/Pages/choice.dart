import 'package:flutter/material.dart';
import 'package:career_coach/Pages/signupUser_page.dart';
import 'package:career_coach/Pages/signupCoach_page.dart';
import 'package:compass_icon/compass_icon.dart';

class choicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            
              // Image for User button
              GestureDetector(
                onTap: () {
                  // Redirects to SignupPageUser when the image is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPageUser()),
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Stack(
                    children: [
                      // FadeInImage widget for the User image
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.gif',
                        image: 'assets/images/user.jpg',
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      // Positioned text at the bottom when hovered
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'User',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              // Image for Coach button
              GestureDetector(
                onTap: () {
                  // Redirects to SignupPageCoach when the image is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPageCoach()),
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Stack(
                    children: [
                      // FadeInImage widget for the Coach image
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.gif',
                        image: 'assets/images/coach.jpg',
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      // Positioned text at the bottom when hovered
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Coach',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
