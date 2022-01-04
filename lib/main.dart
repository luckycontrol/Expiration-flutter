import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/home.dart';
import 'package:food_manager/screen/Account/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "esamanru"
      ),
      home: auth.currentUser == null ? Login() : Home()
    );
  }
}

