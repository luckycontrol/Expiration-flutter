import 'package:flutter/material.dart';
import 'package:food_manager/model/item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_manager/screen/Home/Edit/edit.dart';
import 'dart:io';

class ItemCard extends StatelessWidget {

  Item item;
  List<String> categories;
  void Function(Item) editItem;
  void Function(Item) removeItem;
  
  ItemCard ({ 
    Key? key, 
    required this.item,
    required this.categories,
    required this.editItem,
    required this.removeItem
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => Edit(item: item, categories: categories, editItem: editItem))),
            label: '수정',
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(context: context, builder: buildDeleteModal);
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
            // FIXME: 사진
            CircleAvatar(
              backgroundImage: FileImage(File(item.image.path)),
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

  Widget buildDeleteModal(BuildContext context) {
    return AlertDialog(
      title: Text("${item.name}을/를 삭제하실건가요?"),
      content: Container(
        height: 80,
        child: Column(
          children: [
            SizedBox(height: 10),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
                primary: Colors.red[400]
              ),
              child: Text("삭제하기"),
              onPressed: () { 
                removeItem(item);
                Navigator.of(context).pop();
              }
            )
          ],
        )
      )
    );
  }
}