import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

void sendNotificationForeground() {
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      if (message.notification != null) {
        if (kDebugMode) {
          print('Got a message whilst in the foreground!');
        }
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
          print('====== ${message.notification!.title}');
          print('====== ${message.notification!.body}');
        }
        //! Add Custom Notification here like (Snackbar)
      }
    },
  );
}
