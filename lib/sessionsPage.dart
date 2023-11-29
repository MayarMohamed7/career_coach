import 'package:career_coach/models/Session.dart';
import 'package:flutter/material.dart';

class sessionPage extends StatelessWidget {
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
          title: const Text("Choose your session"),
        ),
        body: ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: ListTile(
                      title: Text(sessions[index].name),
                      subtitle: Text('${sessions[index].price} EGP'),
                      trailing: ElevatedButton(
                        onPressed: null,
                        child: const Text('Reserve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // This is the background color
                          foregroundColor: Colors
                              .white, // This is the color of the text and icons
                        ),
                      ),
                    ),
                  ));
            }));
  }
}
