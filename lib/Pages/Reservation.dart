import 'package:career_coach/Pages/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  late String userId;

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
        content: Text('Reservation canceled'),
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
    final TimeOfDay time = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    final String formattedDate = dateFormat.format(date);
    final String formattedTime = time.format(context);
    return '$formattedDate at $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Reservations'),
      ),
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reservations found.'));
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
                  if (sessionSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (sessionSnapshot.hasData && sessionSnapshot.data!.exists) {
                    var sessionData =
                        sessionSnapshot.data!.data() as Map<String, dynamic>;
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
                          onPressed: () {
                            deleteReserved(reservations[index].id, reserved);
                          },
                          icon: Icon(Icons.cancel),
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else {
                    return Card(
                      child: ListTile(
                        title: Text('Coach Name: ${reserved['coachName']}'),
                        subtitle: Text('Session details not found'),
                        trailing: IconButton(
                          onPressed: () {
                            deleteReserved(reservations[index].id, reserved);
                          },
                          icon: Icon(Icons.cancel),
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
    );
  }
}