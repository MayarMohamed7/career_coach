import 'package:career_coach/Pages/mySessions.dart';
import 'package:career_coach/Pages/newSession.dart';
import 'package:flutter/material.dart';

class CoachHome extends StatelessWidget {
  const CoachHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCard(
              context,
              title: 'View My Sessions',
              icon: Icons.view_list,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => mySessions()));
              },
            ),
            _buildCard(
              context,
              title: 'Add New Session',
              icon: Icons.add_circle_outline,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewSession()));
              },
            ),
            // Add more cards if needed
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
