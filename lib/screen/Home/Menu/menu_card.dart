import 'package:flutter/material.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:get/get.dart';

class MenuCard extends StatelessWidget {
  MenuCard({ 
    Key? key, 
    required this.name,
    required this.isEdit,
  }) : super(key: key);
  
  final CategoryController cc = Get.find();

  String name;
  bool isEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { 
        cc.selectCategory(name);
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          color: name == cc.selectedCategory.value ? Colors.black.withOpacity(0.3) : null,
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            name,
            style: TextStyle(
              fontWeight: name == cc.selectedCategory.value ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
              fontSize: 18.0
            )
          ),
        ),
      )
    );
  }
}