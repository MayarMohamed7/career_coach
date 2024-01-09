import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:career_coach/utils/utils.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  final DateFormat formatter = DateFormat('MMMM dd, yyyy, hh:mm a');
  return formatter.format(dateTime);
}

class reserveeDetails extends StatefulWidget {
  const reserveeDetails({super.key, required this.reservationId});
  final String reservationId;

  @override
  State<reserveeDetails> createState() => _reserveeDetailsState();
}

class _reserveeDetailsState extends State<reserveeDetails> {
  Map<String, dynamic>? reservationDetails;
  String? reserveeName;

  @override
  void initState() {
    super.initState();
    fetchReservationDetails();
  }

  Future<void> fetchReservationDetails() async {
    try {
      DocumentSnapshot reservationDoc = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(widget.reservationId)
          .get();

      if (reservationDoc.exists) {
        var reservationData = reservationDoc.data() as Map<String, dynamic>?;
        String userId = reservationData?['userId'];
        var fetchedname = await FirestoreService.fetchUserName(userId);
        setState(() {
          reservationDetails = reservationData;
          reserveeName = fetchedname;
        });
      }
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reservationDetails == null || reserveeName == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff0f4f6c),
          title: const Text('Reservation Details'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reservee Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                reserveeName!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Date & Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                formatDate(DateTime.fromMillisecondsSinceEpoch(
                                    reservationDetails!['timestamp']
                                        .millisecondsSinceEpoch)),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Add other reservation details here
                  ],
                ),
              ),
            ),
            // Add any additional buttons or actions here
          ],
        ),
      ),
    );
  }
}
