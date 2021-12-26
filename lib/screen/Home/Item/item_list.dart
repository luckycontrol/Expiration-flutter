import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Item/item_card.dart';
import 'package:food_manager/model/item.dart';

class ItemList extends StatefulWidget {
  ItemList({ Key? key, required this.item_list }) : super(key: key);

  List<Item> item_list;

  @override
  State<ItemList> createState() => _ItemListState(item_list: item_list);
}

class _ItemListState extends State<ItemList> {

  _ItemListState({ required this.item_list });

  List<Item> item_list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      child: Column(
        children: item_list.map((item) => ItemCard(item: item, deleteItem: () {
          setState(() {
            item_list.remove(item);
          });
        })).toList(),
      )
    );
  }
}