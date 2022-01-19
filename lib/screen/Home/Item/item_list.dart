import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Item/item_card.dart';
import 'package:food_manager/model/item.dart';

class ItemList extends StatelessWidget {
  ItemList ({ 
    Key? key, 
    required this.item_list,
  }) : super(key: key);

  List<Item> item_list;

  @override
  Widget build(BuildContext context) {
    return item_list.length > 0
    ? Column(
      children: item_list.map((item) => ItemCard(item)).toList(),
    )
    : const Padding(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Text(
        "우측 상단에 +버튼을 눌러 품목을 추가해보세요!", 
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 17),
      )
    );
  }
}