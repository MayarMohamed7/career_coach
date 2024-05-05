import 'package:career_coach/Pages/Coachnotifications.dart';
import 'package:career_coach/Pages/coachHome.dart';
import 'package:career_coach/Pages/reserveeDetails.dart';
import 'package:career_coach/models/Session.dart';
import 'package:career_coach/providers/sessions_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:career_coach/Pages/profileCoach.dart';
import 'package:career_coach/Pages/chatPage.dart';
import 'package:career_coach/Pages/home.dart';
import 'package:career_coach/Pages/firebase_messaging.dart';
import 'package:career_coach/Pages/payment_page.dart';
import 'package:career_coach/utils/utils.dart';
import 'package:career_coach/Pages/DetailsCoach.dart';

class mySessions extends ConsumerStatefulWidget {
  const mySessions({Key? key});

  @override
  _mySessionsState createState() => _mySessionsState();
}

class _mySessionsState extends ConsumerState<mySessions> {
  String coachId = FirebaseAuth.instance.currentUser!.uid;
int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  ProfilePagecoach()),
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
    else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CoachHome()),
      );
      
    }
  }

  @override
  void initState() {
    super.initState();
    ref.read(sessionProvider(coachId).notifier).fetchSessions(coachId);
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      // Fetch session data before deleting
      DocumentSnapshot sessionDoc = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .get();
      var sessionData = sessionDoc.data() as Map<String, dynamic>?;

      if (sessionData != null) {
        await FirebaseFirestore.instance
            .collection('sessions')
            .doc(sessionId)
            .delete();
        ref.read(sessionProvider(coachId).notifier).fetchSessions(coachId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Session deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('sessions')
                    .doc(sessionId)
                    .set(sessionData);
                ref.read(sessionProvider(coachId).notifier).fetchSessions(coachId);
              },
            ),
          ),
        );
      } else {
        throw Exception('Session data not found');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting session: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Session> sessions = ref.watch(sessionProvider(coachId));

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'My Sessions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: sessions.isNotEmpty
                  ? ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        var session = sessions[index];
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(session.date);
                        String formattedTime =
                            session.time.format(context);

                        Color statusColor;
                        String statusText = session.status;
                        bool isReserved = true;

                        switch (statusText) {
                          case 'Not Available':
                            statusColor = Colors.green;
                            statusText = 'Reserved';
                            isReserved = true;
                            break;
                          case 'Available':
                            statusColor = Colors.red;
                            statusText = 'Not Reserved';
                            isReserved = false;
                            break;
                          default:
                            statusColor = Colors.grey;
                            statusText = 'Unknown';
                            break;
                        }

                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.business_center_outlined),
                                title: Text('\$${session.price}'),
                                subtitle: Row(
                                  children: [
                                    const Icon(Icons.calendar_today),
                                    const SizedBox(width: 4),
                                    Text(formattedDate),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.access_time),
                                    const SizedBox(width: 4),
                                    Text(formattedTime),
                                  ],
                                ),
                                trailing: isReserved
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          var reservationSnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection('reservations')
                                                  .where('sessionId',
                                                      isEqualTo: session.id)
                                                  .get();

                                          if (reservationSnapshot.docs.isNotEmpty) {
                                            var reservationId =
                                                reservationSnapshot.docs.first.id;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    reserveeDetails(
                                                  reservationId: reservationId,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0F4F6C),
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('View Details'),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          deleteSession(sessions[index].id);
                                        },
                                        icon: Icon(Icons.cancel),
                                        color: Colors.red,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(child: Text('No sessions available')),
            ),
          ],
        ),
     
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
