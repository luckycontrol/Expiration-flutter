import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/home.dart';
import 'package:food_manager/screen/Account/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';


Future<void> _firebaseBackgroundMessagingHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.data);
}

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("메시지 왔다!");

    if (message.notification != null) {
      print(message.notification);
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessagingHandler);
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  
  MyApp({Key? key}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Elice"
      ),
      initialRoute: auth.currentUser == null ? "/login" : "/home",
      routes: {
        "/home": (context) => const Home(),
        "/login": (context) => const Login()
      }
    );
  }
}

