import 'package:career_coach/models/Session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider bs lw h return f w'tha
//lw olt return 42; msln coachId
//.family ba btkhelek t3rf takhod parameter zyada w ele hwa l coachid ele ehna 3yzeno hna
//.get() btrg3 future fa 3shan kda asynchroneous
//When you mark a function as async, it automatically returns a Future
class SessionsNotifier extends StateNotifier<List<Session>> {
  SessionsNotifier() : super([]);

  Future<void> fetchSessions(String coachId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .where('coachId', isEqualTo: coachId)
          .get();

      state = snapshot.docs.map((doc) {
        return Session.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      state = []; // Handle error appropriately
    }
  }

  // Add more methods to update sessions if needed
}

final sessionProvider =
    StateNotifierProvider.family<SessionsNotifier, List<Session>, String>(
        (ref, coachId) {
  return SessionsNotifier()
    ..fetchSessions(
        coachId); //..fetchSessions(coachId):'..' is then used to call fetchSessions(coachId) on the newly created SessionsNotifier instance.
});
