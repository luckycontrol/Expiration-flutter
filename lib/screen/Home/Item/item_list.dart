import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Item/item_card.dart';
import 'package:food_manager/model/item.dart';

class ItemList extends StatelessWidget {
  ItemList ({ 
    Key? key, 
    required this.item_list,
    required this.categories,
    required this.editItem,
    required this.removeItem,
  }) : super(key: key);

  List<Item> item_list;
  List<String> categories;
  void Function(Item, bool) editItem;
  void Function(Item) removeItem;

  @override
  Widget build(BuildContex) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      child: Column(
        children: item_list.map((item) => ItemCard(item, categories, editItem, removeItem)).toList(),
      )
    );
  }
}