import 'dart:convert';
import 'package:firebase_app/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

 //! Send Notification API
sendNotificationAPIRequest(title, message) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAaX9G6R0:APA91bG9MX0lfn-BNZdTQHAm_bYsXtju-B5y4TQzSwc3yv5HqYiTU2HO16ipF2HQ6Sp_MpkEXpvIBNOuAwHTCUei6bUdTkY94AV1cSIpfjDxNJGErPghTfb_GVBeOyy-2NrkXMW9v5aQ'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "$tokenMessaging",
    "notification": {
      "title": title,
      "body": message,
    },
    "data": {
      "id": "33",
      "name": "Ali",
    },
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    if (kDebugMode) {
      print(resBody);
    }
    if (kDebugMode) {
      print("Sueccessful notification send");
    }
  } else {
    if (kDebugMode) {
      print(res.reasonPhrase);
    }
    if (kDebugMode) {
      print("Failed notification send");
    }
  }
}

//! send notification to topic

sendNotificationAPIRequestTopic(title, message, topic) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAaX9G6R0:APA91bG9MX0lfn-BNZdTQHAm_bYsXtju-B5y4TQzSwc3yv5HqYiTU2HO16ipF2HQ6Sp_MpkEXpvIBNOuAwHTCUei6bUdTkY94AV1cSIpfjDxNJGErPghTfb_GVBeOyy-2NrkXMW9v5aQ'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "/topics/$topic",
    "notification": {
      "title": title,
      "body": message,
    },
    "data": {
      "id": "33",
      "name": "Ali",
    },
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    if (kDebugMode) {
      print(resBody);
    }
    if (kDebugMode) {
      print("Sueccessful notification send");
    }
  } else {
    if (kDebugMode) {
      print(res.reasonPhrase);
    }
    if (kDebugMode) {
      print("Failed notification send");
    }
  }
}
