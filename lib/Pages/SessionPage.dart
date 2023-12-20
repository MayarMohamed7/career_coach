import 'package:career_coach/Pages/chat.dart';
import 'package:career_coach/Pages/payment_page.dart';
import 'package:career_coach/Pages/profileCoach.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class coachsessionsPage extends StatefulWidget {
  final String coachId;
  final String coachName;

  const coachsessionsPage(
      {Key? key, required this.coachId, required this.coachName})
      : super(key: key);
  @override
  State<coachsessionsPage> createState() => _coachingsessionsPageState();
}

class _coachingsessionsPageState extends State<coachsessionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Coaching Sessions'),
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('sessions')
                  .where('status', isEqualTo: 'available')
                  .where('coachId', isEqualTo: widget.coachId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var sessions = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    var session =
                        sessions[index].data() as Map<String, dynamic>;
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
                                builder: (context) => PaymentPage(
                                    sessionId: sessionId,
                                    coachName: widget.coachName),
                              ),
                            );
                          },
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
            ),
          ),
        ],
      ),
    );
  }
}
