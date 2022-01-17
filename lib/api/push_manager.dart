import 'dart:convert';
import 'dart:io';
import 'package:food_manager/model/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushManager {

  void setAlarm(String email, DateTime time) async {

    String? token = await FirebaseMessaging.instance.getToken();

    User user = User(
      email: email,
      token: token!,
      time: time.toIso8601String()
    );

    Map<String, dynamic> _user = user.toJson();
    http.post(
      Uri.parse("https://food-manager-server.herokuapp.com/message"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(_user)
    );
  }
}

PushManager pushManager = PushManager();

