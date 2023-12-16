import 'package:flutter/material.dart';
import 'package:career_coach/models/Session.dart';

import 'details.dart';
import 'menu.dart';

class SessionPage extends StatelessWidget {
  final List<Session> sessions = [
    Session(name: 'Session with Iwan Ashton', price: 150),
    Session(name: "Session with Lyra Fox", price: 450),
    Session(name: "Session with Ali Othman", price: 300),
    Session(name: "Session with Kenan Mohamed", price: 500)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: const Text("Choose your session"),
      ),
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              child: ListTile(
                title: Text(sessions[index].name),
                subtitle: Text('${sessions[index].price.toString()} EGP'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoachingSessionPage(),
                      ),
                    );
                  },
                  child: const Text('Reserve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0f4f6c),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SessionDetailsPage extends StatelessWidget {
  final Session session;

  SessionDetailsPage({required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Session Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Session: ${session.name}"),
            Text("Price: ${session.price} EGP"),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
