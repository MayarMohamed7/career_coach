import 'package:career_coach/Pages/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<void> deleteReserved(String sessionId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('reservations').doc(sessionId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reservation canceled'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            FirebaseFirestore.instance.collection('reservations').add(data);
          },
        ),
      ),
    );
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
                future: FirebaseFirestore.instance.collection('sessions').doc(sessionId).get(),
                builder: (context, sessionSnapshot) {
                  if (sessionSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (sessionSnapshot.hasData && sessionSnapshot.data!.exists) {
                    var sessionData = sessionSnapshot.data!.data() as Map<String, dynamic>;

                    return Card(
                      child: ListTile(
                        title: Text('Coach Name: ${reserved['coachName']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: \$${sessionData['price']}'),
                            Text('Time: ${sessionData['time']}'),
                            Text('Date: ${sessionData['date']}'),
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
