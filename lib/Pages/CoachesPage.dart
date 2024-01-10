import 'package:career_coach/Pages/SessionPage.dart';
import 'package:career_coach/Pages/chatPage.dart';
import 'package:career_coach/Pages/firebase_messaging.dart';
import 'package:career_coach/Pages/home.dart';
import 'package:career_coach/Pages/menu.dart';
import 'package:career_coach/Pages/profileUser.dart';
import 'package:career_coach/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoachesPage extends StatefulWidget {
  final String? coachName;

  const CoachesPage({Key? key, this.coachName});

  @override
  State<CoachesPage> createState() => _CoachesPageState();
}

class _CoachesPageState extends State<CoachesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _coaches =
      FirebaseFirestore.instance.collection('coaches');

  final StorageMethods _storageMethods = StorageMethods();

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePageUser()),
      );
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationsPage()),
      );
    }
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Available Coaches',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _coaches.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final coaches = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: coaches.length,
                  itemBuilder: (context, index) {
                    var coach = coaches[index].data() as Map<String, dynamic>;
                    var coachId = coaches[index].id;
                    var coachImagePath =
                        coach['assets/images/coach.png'] ?? '';

                    return FutureBuilder<String?>(
                      future: _storageMethods.getProfileImg(coachId),
                      builder: (context, snapshot) {
                        var coachImageURL = snapshot.data;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: coachImageURL != null
                                        ? NetworkImage(coachImageURL)
                                        : AssetImage(
                                            'assets/images/coach.png') as ImageProvider<Object>,
                                    radius: 25,
                                  ),
                                  title: Text(
                                    '${coach['firstName'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                coachsessionsPage(
                                              coachId: coachId,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFF0F4F6C),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        'Show Available Sessions',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    _storageMethods.showRatingDialog(
                                        context, coachId);
                                  },
                                  child: const Text('Rate Coach'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F4F6C),
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
