import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_manager/model/item.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:get/get.dart';
import 'dart:io';

class AddCard extends StatelessWidget {

  Item item;
  Function(Item) deleteItem;

  CategoryController cc = Get.find();

  AddCard({ Key? key, required this.item, required this.deleteItem }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => deleteItem(item),
            label: "삭제",
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!
            )
          ),
        ),
        child: Row(
          children: [
            // 이미지
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(item.image)),
                  fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.black
              )
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이름
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 8),
                // 카테고리
                Text(
                  "${cc.selectedCategory}"
                )
              ],
            ),
            const Spacer(),
            Text(
              "${item.expiration.year}년 ${item.expiration.month}월 ${item.expiration.day}일 까지",
            )
          ],
        )
      )
    );
  }
}