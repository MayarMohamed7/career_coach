import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? userId; // Set the user ID here

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
    getUserId();
  }

  void _initializeFirebaseMessaging() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: $message');
      // Handle incoming messages when the app is in the foreground
      // You can use this data to display a notification to the user or handle other tasks
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('User tapped on the notification when the app was in the background!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      // Handle notifications that were tapped when the app was in the background
    });
  }

  Future<void> getUserId() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  void deleteNotification(String notificationId) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  Map<String, dynamic>? dismissedNotification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xff0f4f6c),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var notifications = snapshot.data!.docs;
          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notificationData =
                  notifications[index].data() as Map<String, dynamic>;
              String notificationId = notifications[index].id;

              return Dismissible(
                key: Key(notificationId),
                onDismissed: (direction) {
                  dismissedNotification = notificationData;

                  deleteNotification(notificationId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Notification deleted"),
                      action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          if (dismissedNotification != null) {  
                            FirebaseFirestore.instance
                                .collection('notifications')
                                .doc(notificationId)
                                .set(dismissedNotification!);
                            dismissedNotification = null;
                          }
                        },
                      ),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: ListTile(
                  title: Text(notificationData['title']),
                  subtitle: Text(notificationData['body']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
