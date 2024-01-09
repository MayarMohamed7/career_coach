import 'package:career_coach/Pages/reserveeDetails.dart';
import 'package:career_coach/models/Session.dart';
import 'package:career_coach/providers/sessions_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class mySessions extends ConsumerStatefulWidget {
  const mySessions({super.key});

  @override
  _mySessionsState createState() => _mySessionsState();
}

class _mySessionsState extends ConsumerState<mySessions> {
  String coachId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    // Trigger fetching sessions when the widget is first built
    ref.read(sessionProvider(coachId).notifier).fetchSessions(coachId);
  }

  @override
  Widget build(BuildContext context) {
    List<Session> sessions = ref.watch(sessionProvider(coachId));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff0f4f6c),
          title: const Text('My Sessions'),
        ),
        body: Column(children: [
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
                          statusColor =
                              Colors.grey; // Default color for unknown status
                          statusText =
                              'Unknown'; // Default text for unknown status
                          break;
                      }
                      return Card(
                        child: ListTile(
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
                          trailing: isReserved
                              ? ElevatedButton(
                                  onPressed: () async {
                                    // Fetch the reservation ID for this session
                                    var reservationSnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('reservations')
                                            .where('sessionId',
                                                isEqualTo: session.id)
                                            .get();

                                    if (reservationSnapshot.docs.isNotEmpty) {
                                      var reservationId =
                                          reservationSnapshot.docs.first.id;
                                      // Navigate to ReserveeDetails with the reservation ID
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => reserveeDetails(
                                              reservationId: reservationId),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff0f4f6c),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('View Details'),
                                )
                              : null,
                        ),
                      );
                    })
                : const Center(child: Text('No sessions available')),
          )
        ]));
  }
}
