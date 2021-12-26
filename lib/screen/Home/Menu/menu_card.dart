import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  MenuCard({ Key? key, required this.name, required this.selectedCategory, required this.changeCategory }) : super(key: key);

  String name;
  String selectedCategory;
  void Function(String) changeCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () { 
          changeCategory(name);
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: selectedCategory == name ? Colors.black.withOpacity(0.4) : Colors.transparent
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: selectedCategory == name ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          )
        ),
      ),
    );
  }
}