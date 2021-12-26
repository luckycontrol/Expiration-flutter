import 'package:flutter/material.dart';
import 'package:food_manager/screen/loading.dart';
import 'package:food_manager/screen/Home/home.dart';
import 'package:food_manager/screen/Home/Option/option.dart';
import 'package:food_manager/screen/Account/create.dart';
import 'package:food_manager/screen/Account/login.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    fontFamily: 'Elice'
  ),
  initialRoute: '/home/main',
  routes: {
    '/home/main': (context) => Home(),
    '/home/option': (context) => Option(),
    '/account/login': (context) => Login(),
    '/account/create': (context) => CreateAccount(),
  },
));

