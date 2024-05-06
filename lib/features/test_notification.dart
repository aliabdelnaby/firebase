import 'package:firebase_app/core/functions/notification/send_notification_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TestNotification extends StatefulWidget {
  const TestNotification({super.key});

  @override
  State<TestNotification> createState() => _TestNotificationState();
}

class _TestNotificationState extends State<TestNotification> {
  @override
  void initState() {
    sendNotificationForeground();
    getToken();
    requestPermissionNotification();
    super.initState();
  }

  void sendNotificationForeground() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        if (message.notification != null) {
          if (kDebugMode) {
            print('====== Got a message whilst in the foreground!');
          }
          if (kDebugMode) {
            print(
                'Message also contained a notification: ${message.notification}');
            print('====== ${message.notification!.title}');
            print('====== ${message.notification!.body}');
          }
          //! Add Custom Notification here like (Snackbar)

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${message.notification!.title} , ${message.notification!.body}',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
    );
  }

  getToken() async {
    FirebaseMessaging.instance.getToken().then(
      (value) {
        if (kDebugMode) {
          print(value);
        }
      },
    ).catchError(
      (e) {
        if (kDebugMode) {
          print(e);
        }
      },
    );
  }

  requestPermissionNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(vertical: 200),
        child: TextButton.icon(
          onPressed: () async {
            await sendNotificationAPIRequest("Test", "done!!!!");
          },
          icon: const Icon(Icons.send),
          label: const Text("Send Notification"),
        ),
      ),
    );
  }
}
