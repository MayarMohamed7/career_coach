import 'package:career_coach/Pages/SessionPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoachesPage extends StatefulWidget {
  final String? coachName;
  const CoachesPage({super.key, this.coachName});

  @override
  State<CoachesPage> createState() => _CoachesPageState();
}

class _CoachesPageState extends State<CoachesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _coaches =
      FirebaseFirestore.instance.collection('coaches');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0f4f6c),
          title: Text('Coaches'),
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('coaches').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              var coaches = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: coaches.length,
                  itemBuilder: (context, index) {
                    var coach = coaches[index].data();
                    var coachId = coaches[index].id;
                    return Card(
                        child: ListTile(
                      leading: Icon(Icons.business_center_outlined),
                      title: Text('${coach['firstName']}'),
                      /*subtitle: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 4),
                          Text(session['date']),
                          SizedBox(width: 10),
                          Icon(Icons.access_time),
                          SizedBox(width: 4),
                          Text(session['time']),
                        ],
                      ),*/
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => coachsessionsPage(
                                coachId: coachId,
                                coachName:
                                    coach['firstName'] ?? 'No Coach Name',
                              ),
                            ),
                          );
                        },
                        child: const Text('Show available sessions'),
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
