import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class Loading extends StatefulWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingBouncingGrid.square(
          size: 50.0,
          backgroundColor: Colors.red,
        )
      ),
    );
  }
}