import 'package:flutter/material.dart';
import 'package:food_manager/model/item.dart';

class ExpireCard extends StatelessWidget {

  Item item;

  ExpireCard({ Key? key, required this.item }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(item.image)
          ),
          const SizedBox(height: 10),
          Text(item.name)
        ],
      ),
    );
  }

  // 유통기한이 얼마 안남은 품목 확인하는 위젯
  Widget checkProduct(BuildContext context) {
    return Container(
      
    );
  }
}