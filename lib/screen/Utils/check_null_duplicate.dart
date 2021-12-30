import 'package:flutter/material.dart';

class CheckCategoryNullDuplicate extends StatelessWidget {

  String message;

  CheckCategoryNullDuplicate({ required this.message });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red[300],
    );
  }
}

