import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  const Option({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("설정"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 3,
        
      ),
      body: Center(
        child: Text("OPTION")
      )
    );
  }
}