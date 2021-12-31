import 'package:flutter/material.dart';

class AlertMessageDialog extends StatelessWidget {

  String message;

  AlertMessageDialog({ required this.message });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message, style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
      backgroundColor: Colors.red[300],
    );
  }
}

