import 'package:career_coach/Pages/Reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String sessionId;
  final String coachName;

  const OTPScreen({super.key, required this.sessionId, required this.coachName});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0f4f6c),
        foregroundColor: Colors.white,
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP'),
              validator: (value) {
                if (value == null || value.isEmpty || value.length != 6) {
                  return 'Please enter a valid 6-digit OTP';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Verify OTP logic
                if (otpController.text.length == 6) {
                  // Save reservation details to Firebase
                  String userId = FirebaseAuth.instance.currentUser!
                      .uid; // Replace with the actual user ID

                  _saveReservation(userId, widget.sessionId, widget.coachName);

                  // Change status to "unavailable" in sessions table
                  await updateSessionStatus(widget.sessionId);

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Verification'),
                      content: const Text('Verified and reservation done.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Okay'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const ReservationsPage()),
                            ); // Close the dialog
                            // Optionally navigate away or perform other actions
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0f4f6c),
                foregroundColor: Colors.white,
              ),
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveReservation(
      String userId, String sessionId, String coachName) async {
    FirebaseFirestore.instance.collection('reservations').add({
      'userId': userId,
      'sessionId': sessionId,
      'timestamp': FieldValue.serverTimestamp(),
      'coachName': coachName
    });
  }

  Future<void> updateSessionStatus(String sessionId) async {
    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .update({
      'status': 'Not Available',
    });
  }
}
