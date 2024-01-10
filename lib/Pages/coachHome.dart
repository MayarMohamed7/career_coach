import 'package:career_coach/Pages/Coachnotifications.dart';
import 'package:career_coach/Pages/chat.dart';
import 'package:career_coach/Pages/firebase_messaging.dart';
import 'package:career_coach/Pages/DetailsCoach.dart';
import 'package:career_coach/Pages/mySessions.dart';
import 'package:career_coach/Pages/newSession.dart';
import 'package:career_coach/Pages/profileCoach.dart';
import 'package:flutter/material.dart';

class CoachHome extends StatefulWidget {
  const CoachHome({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CoachHome> {
  final List<String> imageList = [
    'assets/images/one.png',
    'assets/images/two.png',
    'assets/images/three.png',
    'assets/images/four.png',
  ];

  int _currentPage = 0;
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  ProfilePageUser()),
      );
    } 
    else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  ChatScreen()),
      );
      
    }
    else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CoachNotificationsPage()),
      );
      
    }
  }

  void _previousImage() {
    setState(() {
      _currentPage = (_currentPage - 1).clamp(0, imageList.length - 1);
    });
  }

  void _nextImage() {
    setState(() {
      _currentPage = (_currentPage + 1).clamp(0, imageList.length - 1);
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
      endDrawer: const Drawer(
        child: DetailsPage(),
      ),
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
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome to Career Compass!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 242, 242, 242),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/carcoach.jpg',
                      
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Now you can do your job easily!',
                        style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 242, 242, 242),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildCard(
                      context,
                      title: 'View My Sessions',
                      icon: Icons.view_list,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => mySessions()),
                        );
                      },
                    ),
                    _buildCard(
                      context,
                      title: 'Add New Session',
                      icon: Icons.add_circle_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewSession()),
                        );
                      },
                    ),
                    // Add more cards if needed
                  ],
                ),
              ],
            ),
          ),
        ],
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
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
