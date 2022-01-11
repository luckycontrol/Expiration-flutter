import 'dart:convert';
import 'package:food_manager/model/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushManager {

  void setAlarm(String email, DateTime time) async {

    String? token = await FirebaseMessaging.instance.getToken();

    User user = User(
      email: email,
      token: token!,
      time: time
    );

    Map<String, dynamic> _user = user.toJson();
    http.post(
      Uri.parse("localhost:8800/message"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(_user)
    );
  }
}

PushManager pushManager = PushManager();

