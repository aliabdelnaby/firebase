import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("======= background message: ${message.messageId}");
    print('${message.notification!.title}');
    print('${message.notification!.body}');
  }
}
