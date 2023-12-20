import 'package:flutter/material.dart';
import 'menu.dart';
import 'sessionsPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: const Text('Career Compass'),
      ),
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/background.jpg',
                width: 300,
                height: 300,
              ),
            ),
            const Text(
              "Welcome to Career Compass",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "We will help you find your best career path.",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SessionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff0f4f6c),
              ),
              child: const Text("Show Available Sessions"),
            ),
          ],
        ),
      ),
    );
  }
}
