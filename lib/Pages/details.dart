import 'package:flutter/material.dart';
import 'package:career_coach/Pages/payment_page.dart';

import 'menu.dart';

class CoachingSessionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Coaching Session Details'),
      ),
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coach Name: John Doe',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Working hours : Sunday - Thursday (9:00AM - 3:00PM)'),
            SizedBox(height: 8),
            Text('Coach Rating: 4.5/5'),
            SizedBox(height: 8),
            Text('Price: \$50'),
            SizedBox(height: 8),
            Text('Awards: Best Coach of the Year, 2022'),
            SizedBox(height: 8),
            Text(
              'About the Coach:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'John Doe is a highly experienced coach with a proven track record of helping individuals achieve their goals. He has received numerous awards for his outstanding contributions to the coaching community.',
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff0f4f6c),
              ),
              child: Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
