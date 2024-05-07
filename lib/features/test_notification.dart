import 'package:firebase_app/const.dart';
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
    getInitialMessageNotification(context);
    onMessageOpenedAppNotification();
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
            print('====== ${message.data}');
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

  void getToken() async {
    String? myTokenMessaging = await FirebaseMessaging.instance.getToken();

    if (kDebugMode) {
      print(myTokenMessaging);
    }
    tokenMessaging = myTokenMessaging;
  }

  void requestPermissionNotification() async {
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

  void onMessageOpenedAppNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        if (message.data['type'] == 'home') {
          Navigator.of(context).pushNamed("home");
        }

        if (kDebugMode) {
          print('========onMessageOpenedApp: ${message.notification}');
        }

        if (kDebugMode) {
          print('========onMessageOpenedApp: ${message.notification!.title}');
        }
        if (kDebugMode) {
          print('========onMessageOpenedApp: ${message.notification!.body}');
        }
        if (kDebugMode) {
          print('========onMessageOpenedApp: ${message.data}');
        }
      },
    );
  }

  void getInitialMessageNotification(context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.data['type'] == 'home') {
        Navigator.of(context).pushNamed("home");
      }

      if (kDebugMode) {
        print('========onInitialMessage: ${initialMessage.notification}');
      }

      if (kDebugMode) {
        print(
            '========onInitialMessage: ${initialMessage.notification!.title}');
      }
      if (kDebugMode) {
        print('========onInitialMessage: ${initialMessage.notification!.body}');
      }
      if (kDebugMode) {
        print('========onInitialMessage: ${initialMessage.data}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () async {
                await FirebaseMessaging.instance.subscribeToTopic('ali');
              },
              icon: const Icon(
                Icons.send,
                color: Colors.orange,
              ),
              label: const Text(
                "subscribe",
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                await FirebaseMessaging.instance.unsubscribeFromTopic('ali');
              },
              icon: const Icon(Icons.send),
              label: const Text("unsubscribe"),
            ),
            TextButton.icon(
              onPressed: () async {
                await sendNotificationAPIRequestTopic(
                  "Test",
                  "done!!!!",
                  "ali",
                );
              },
              icon: const Icon(
                Icons.send,
                color: Colors.red,
              ),
              label: const Text(
                "Send Notification Topic",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
