// CoachesPage class
import 'package:career_coach/Pages/SessionPage.dart';
import 'package:career_coach/Pages/menu.dart';
import 'package:career_coach/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoachesPage extends StatefulWidget {
  final String? coachName;
  const CoachesPage({Key? key, this.coachName}) : super(key: key);

  @override
  State<CoachesPage> createState() => _CoachesPageState();
}

class _CoachesPageState extends State<CoachesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _coaches =
      FirebaseFirestore.instance.collection('coaches');

  final StorageMethods storageMethods = StorageMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f4f6c),
        title: Text('Coaches'),
      ),
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: StreamBuilder(
        stream: _coaches.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final coaches = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: coaches.length,
            itemBuilder: (context, index) {
              var coach = coaches[index].data() as Map<String, dynamic>;
              var coachId = coaches[index].id;
              var coachImagePath = coach['assets/images/coach.png'] ?? '';

              return FutureBuilder<String?>(
                future: storageMethods.getCoachImageURL(coachImagePath),
                builder: (context, snapshot) {
                  var coachImageURL = snapshot.data;

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: coachImageURL != null
                          ? NetworkImage(coachImageURL)
                          : AssetImage('assets/images/coach.png') as ImageProvider<Object>,
                        radius: 25,
                      ),
                      title: Text('${coach['firstName']}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => coachsessionsPage(
                                coachId: coachId,
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
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
