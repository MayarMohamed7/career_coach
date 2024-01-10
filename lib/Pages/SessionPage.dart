import 'package:career_coach/Pages/chatPage.dart';
import 'package:career_coach/Pages/firebase_messaging.dart';
import 'package:career_coach/Pages/home.dart';
import 'package:career_coach/Pages/payment_page.dart';
import 'package:career_coach/Pages/profileCoach.dart';
import 'package:career_coach/Pages/profileUser.dart';
import 'package:career_coach/models/Session.dart';
import 'package:career_coach/providers/sessions_provider.dart';
import 'package:career_coach/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'menu.dart';

class coachsessionsPage extends ConsumerStatefulWidget {
  final String coachId;
  const coachsessionsPage({Key? key, required this.coachId});
  @override
  _CoachSessionsPageState createState() => _CoachSessionsPageState();
}

class _CoachSessionsPageState extends ConsumerState<coachsessionsPage> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching sessions when the widget is first built
    ref
        .read(sessionProvider(widget.coachId).notifier)
        .fetchSessions(widget.coachId);
  }
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
  Widget build(BuildContext context) {
    List<Session> sessions = ref.watch(sessionProvider(widget.coachId));

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
            'Available Sessions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ChatScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0f4f6c),
                      foregroundColor: Colors.white),
                  child: const Text('Start Chat'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePageCoach()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0f4f6c),
                      foregroundColor: Colors.white),
                  child: const Text('View Profile'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
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
                        bool isReservable = true;

                        switch (statusText) {
                          case 'Available':
                            statusColor = Colors.green;
                            break;
                          case 'Not Available':
                            statusColor = Colors.red;
                            isReservable = false;
                            break;
                          default:
                            statusColor =
                                Colors.grey; // Default color for unknown status
                            statusText =
                                'Unknown'; // Default text for unknown status
                            break;
                        }

                        return FutureBuilder<String>(
                          future:
                              FirestoreService.fetchCoachName(session.coachId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Oops! Something went wrong'));
                            }
                            String coachName = snapshot.data ?? 'No Coach Name';
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${session.price}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: isReservable
                                              ? () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PaymentPage(
                                                        sessionId: session.id,
                                                        coachName: coachName,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              : null,  
                                          style: ElevatedButton.styleFrom(
                                            primary: isReservable
                                                ? Color(0xff0f4f6c)
                                                : const Color.fromARGB(255, 255, 255, 255),
                                          ),
                                          child: const Text(
                                            'Reserve',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
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
                                    const SizedBox(height: 8),
                                    Container(
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
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const Center(child: Text('No sessions available')),
            ),
          ],
        ),
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
