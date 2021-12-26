import 'package:flutter/material.dart';
import 'package:food_manager/model/item.dart';

class ExpireCard extends StatelessWidget {

  Item item;

  ExpireCard({ Key? key, required this.item }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: CircleAvatar(
        radius: 25,
        child: Text('Test'),
      ),
    );
  }
}