import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  MenuCard({ 
    Key? key, 
    required this.name,
    required this.isEdit,
    required this.selectedCategory,
    required this.changeCategory 
  }) : super(key: key);

  String name;
  bool isEdit;
  String selectedCategory;
  void Function(String) changeCategory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { 
        changeCategory(name);
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          color: name == selectedCategory ? Colors.black.withOpacity(0.3) : null,
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            name,
            style: TextStyle(
              fontWeight: name == selectedCategory ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
              fontSize: 18.0
            )
          ),
        ),
      )
    );
  }
}