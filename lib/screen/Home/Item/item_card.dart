import 'package:flutter/material.dart';
import 'package:food_manager/model/item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_manager/screen/Home/Edit/edit.dart';
import 'package:food_manager/get/UserController.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:food_manager/get/ProductController.dart';
import 'package:get/get.dart';

class ItemCard extends StatelessWidget {

  final UserController uc = Get.find();
  final CategoryController cc = Get.find();
  final ProductController pc = Get.find();

  Item item;

  List<String> statusList = ["일주일.png", "사흘.png", "하루.png", "지남.png"];
  int status = 0;
  
  ItemCard (this.item, {Key? key}) : super(key: key) {
    DateTime now = DateTime.now();
    DateTime beforeAweek = now.add(const Duration(days: 7));
    DateTime beforeAthree = now.add(const Duration(days: 3));
    DateTime beforeAday = now.add(const Duration(days: 1));

    if (item.expiration.isAfter(beforeAweek)) {
      status = 0;
    }
    else if (item.expiration.isAfter(beforeAthree)) {
      status = 1;
    }
    else if (item.expiration.isAfter(beforeAday)) {
      status = 2;
    }
    else if (item.expiration.day == now.day){
      status = 2;
    }
    else if (item.expiration.isBefore(now)) {
      status = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => Edit(item: item))),
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
            // 사진
            CircleAvatar(
              backgroundImage: NetworkImage(item.image),
              radius: 24
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.name, style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      )),
                      const SizedBox(width: 8),
                      Image.asset("assets/expiration/${statusList[status]}", width: 12, height: 12)
                    ],
                  ),
                  const SizedBox(height: 8),
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
      title: Text("${item.name} 을/를 삭제하실건가요?"),
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
                pc.removeItem(uc.email.value, item);
                Navigator.of(context).pop();
              }
            )
          ],
        )
      )
    );
  }
}