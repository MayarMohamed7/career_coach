import 'package:career_coach/Pages/chat.dart';
import 'package:career_coach/Pages/payment_page.dart';
import 'package:career_coach/Pages/profileCoach.dart';
import 'package:career_coach/models/Session.dart';
import 'package:career_coach/providers/sessions_provider.dart';
import 'package:career_coach/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'menu.dart';

class coachsessionsPage extends ConsumerStatefulWidget {
  final String coachId;
  const coachsessionsPage({Key? key, required this.coachId}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    List<Session> sessions = ref.watch(sessionProvider(widget.coachId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0f4f6c),
        title: const Text('Coaching Sessions'),
      ),
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff0f4f6c),
                      foregroundColor: Colors.white),
                  child: Text('Start Chat'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePageCoach()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff0f4f6c),
                      foregroundColor: Colors.white),
                  child: Text('View Profile'),
                ),
              ),
            ],
          ),
          Expanded(
            child: sessions.isNotEmpty
                ? ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      var session = sessions[index];
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(session.date);
                      String formattedTime = session.time.format(context);

                      Color statusColor;
                      String statusText = session.status;
                      bool isReservable = true;

                      switch (statusText) {
                        case 'Available':
                          statusColor = Colors.green;
                          isReservable = true;
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
                            child: ListTile(
                              leading:
                                  const Icon(Icons.business_center_outlined),
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
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: isReservable
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentPage(
                                              sessionId: session.id,
                                              coachName: coachName,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                                child: const Text('Reserve'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff0f4f6c),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Center(child: Text('No sessions available')),
          ),
        ],
      ),
    );
  }
}
