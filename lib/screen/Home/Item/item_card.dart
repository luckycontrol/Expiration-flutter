import 'package:flutter/material.dart';
import 'package:food_manager/model/item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemCard extends StatelessWidget {

  Item item;
  VoidCallback deleteItem;
  
  ItemCard({ Key? key, required this.item, required this.deleteItem }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          const SlidableAction(
            onPressed: null,
            label: '수정',
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white
          ),
          SlidableAction(
            onPressed: (context) {
              deleteItem();
            },
            label: '삭제',
            backgroundColor: Colors.red[400]!,
            foregroundColor: Colors.white
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!
            )
          )
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  )),
                  Text(
                    "${item.expiration.year}년 ${item.expiration.month}월 ${item.expiration.day}일 까지", 
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ))
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}