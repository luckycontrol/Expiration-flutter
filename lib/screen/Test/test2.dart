import 'package:flutter/material.dart';

class TestList extends StatelessWidget {
  TestList(this.categories);

  List<String> categories;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            height: 60,
            child: Text(category)
          ),
        );
      }).toList(),
    );
  }
}