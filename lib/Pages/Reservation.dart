import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Reservations'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var reservations = snapshot.data!.docs;
          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              var reserved = reservations[index].data() as Map<String, dynamic>;
              var sessionId = reservations[index].id;
              return Card(
                child: ListTile(
                  leading: Icon(Icons.business_center_outlined),
                  title: Text('\$${reserved['sessionId']}'),
                  subtitle: Row(
                    children: [
                      SizedBox(width: 4),
                      Text(reserved['coachName']),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('cancel'),
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
    );
  }
}