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
    getToken();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Container(),
    );
  }
}
