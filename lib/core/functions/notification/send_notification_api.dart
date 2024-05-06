import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

sendNotificationAPIRequest(title, message) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAaX9G6R0:APA91bG9MX0lfn-BNZdTQHAm_bYsXtju-B5y4TQzSwc3yv5HqYiTU2HO16ipF2HQ6Sp_MpkEXpvIBNOuAwHTCUei6bUdTkY94AV1cSIpfjDxNJGErPghTfb_GVBeOyy-2NrkXMW9v5aQ'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to":
        "f469SCStRwKb_gCc3f78oZ:APA91bHyvsdvQbiS-go1ZuN06dwXsbQeo1y2Ky6s17DcwO5S2bZLmLY-4x6hlVp-rtwVc9AifJBraFVbIhXVv4MhKucvu2AK50U8f4onJYJb-qhgUpJxSl77qd3q5i2IXh_L4qRkqhIJ",
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
