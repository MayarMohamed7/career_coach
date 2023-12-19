import 'package:career_coach/Pages/payment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class coachsessionsPage extends StatefulWidget {
  const coachsessionsPage({super.key});

  @override
  State<coachsessionsPage> createState() => _coachingsessionsPageState();
}

class _coachingsessionsPageState extends State<coachsessionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _sessions =
      FirebaseFirestore.instance.collection('sessions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0f4f6c),
          title: Text('Coaching Sessions'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('sessions')
                .where('status', isEqualTo: 'available')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              var sessions = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    var session = sessions[index].data();
                    var sessionId = sessions[index].id;
                    return Card(
                        child: ListTile(
                      leading: Icon(Icons.business_center_outlined),
                      title: Text('\$${session['price']}'),
                      subtitle: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 4),
                          Text(session['date']),
                          SizedBox(width: 10),
                          Icon(Icons.access_time),
                          SizedBox(width: 4),
                          Text(session['time']),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentPage(sessionId: sessionId),
                            ),
                          );
                        },
                        child: const Text('Reserve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0f4f6c),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ));
                  });
            }));
  }
}
