import 'package:career_coach/Pages/chat.dart';
import 'package:career_coach/Pages/firebase_messaging.dart';
import 'package:career_coach/Pages/home.dart';
import 'package:career_coach/Pages/menu.dart';
import 'package:career_coach/Pages/profileUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  late String userId;

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
    } 
    else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  ChatScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationsPage()),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Future<void> deleteReserved(
      String reservationId, Map<String, dynamic> data) async {
    String sessionId = data['sessionId'] as String;
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .delete();

    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .update({'status': 'Available'});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reservation canceled'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('reservations')
                .doc(reservationId)
                .set(data);
            await FirebaseFirestore.instance
                .collection('sessions')
                .doc(sessionId)
                .update({'status': 'Not Available'});
          },
        ),
      ),
    );
  }

  String formatDateTime(DateTime date, int minutes) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final TimeOfDay time =
        TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    final String formattedDate = dateFormat.format(date);
    final String formattedTime = time.format(context);
    return '$formattedDate at $formattedTime';
  }

  Future<void> sendNotificationToUser(String sessionId) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': user.uid,
        'title': 'Reservation Cancelation',
        'body': 'You Canceled your coaching session. Open your reservations for details.',
        'sessionId': sessionId,
      });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Reservations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reservations')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No reservations found.'));
                }
                var reservations = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    var reserved = reservations[index].data() as Map<String, dynamic>;
                    var sessionId = reserved['sessionId'];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('sessions')
                          .doc(sessionId)
                          .get(),
                      builder: (context, sessionSnapshot) {
                        if (sessionSnapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (sessionSnapshot.hasData && sessionSnapshot.data!.exists) {
                          var sessionData = sessionSnapshot.data!.data() as Map<String, dynamic>;
                          DateTime date = (sessionData['date'] as Timestamp).toDate();
                          int minutes = sessionData['time'] as int;

                          String sessionDateTime = formatDateTime(date, minutes);

                          return Card(
                            child: ListTile(
                              title: Text('Coach Name: ${reserved['coachName']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Price: \$${sessionData['price']}'),
                                  Text(sessionDateTime),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  await sendNotificationToUser(sessionId); // Send notification
                                  deleteReserved(reservations[index].id, reserved);
                                },
                                icon: const Icon(Icons.cancel),
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else {
                          return Card(
                            child: ListTile(
                              title: Text('Coach Name: ${reserved['coachName']}'),
                              subtitle: const Text('Session details not found'),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteReserved(reservations[index].id, reserved);
                                },
                                icon: const Icon(Icons.cancel),
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
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
