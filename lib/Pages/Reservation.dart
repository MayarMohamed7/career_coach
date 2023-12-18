import 'package:flutter/material.dart';

import 'menu.dart';

class ReservationListPage extends StatelessWidget {
  const ReservationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0f4f6c),
        title: const Text('Reservations'),
      ),
      endDrawer: Drawer(
        child: DetailsPage(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            ReservationItem(
              reservationId: '123456',
              date: '2023-12-01',
              time: '10:00 AM',
              coachName: 'Mayar Mohamed',
              status: 'Confirmed',
              paymentStatus: 'Paid',
              totalCost: '\$50.00',
            ),
            ReservationItem(
              reservationId: '789012',
              date: '2023-12-02',
              time: '02:30 PM',
              coachName: 'Muhamed Hisham',
              status: 'Pending',
              paymentStatus: 'Pending',
              totalCost: '\$60.00',
            ),
          ],
        ),
      ),
    );
  }
}

class ReservationItem extends StatelessWidget {
  final String reservationId;
  final String date;
  final String time;
  final String coachName;
  final String status;
  final String paymentStatus;
  final String totalCost;

  const ReservationItem({
    super.key,
    required this.reservationId,
    required this.date,
    required this.time,
    required this.coachName,
    required this.status,
    required this.paymentStatus,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff0f4f6c)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reservation ID: $reservationId',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text('Date: $date'),
          Text('Time: $time'),
          Text('Coach: $coachName'),
          Text('Status: $status'),
          Text('Payment Status: $paymentStatus'),
          Text('Total Cost: $totalCost'),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(date),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 5),
                  );

                  if (selectedDate != null) {
                    print('Selected Date: $selectedDate');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0f4f6c),
                ),
                child: const Text('Change Date'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Cancel Reservation'),
                        content: const Text('Are you sure you want to cancel?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
