import 'package:career_coach/Pages/DetailsCoach.dart';
import 'package:career_coach/Pages/profileCoach.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:career_coach/Pages/coachHome.dart'; // Replace with the correct import statements for other pages
import 'package:career_coach/Pages/chatPage.dart';

class CoachNotificationsPage extends StatefulWidget {
  const CoachNotificationsPage({Key? key}) : super(key: key);

  @override
  _CoachNotificationsPageState createState() => _CoachNotificationsPageState();
}

class _CoachNotificationsPageState extends State<CoachNotificationsPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePagecoach()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CoachNotificationsPage()),
      );
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CoachHome()),
      );
    }
  }

  final String coachId = 'coachId'; // Replace 'coachId' with the actual coach's ID

  @override
  void initState() {
    super.initState();
    listenToSessionStatus();
  }

  void listenToSessionStatus() {
    FirebaseFirestore.instance
        .collection('sessions')
        .where('coachId', isEqualTo: coachId)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        if (change.doc['status'] == 'Reserved' &&
            change.type == DocumentChangeType.modified) {
          print('Your session is reserved: ${change.doc.id}');
          // Here you can call a notification service to send a real notification to the coach
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F4F6C),
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
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: Center(
        child: Text('There are no notifications yet'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff0f4f6c),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
