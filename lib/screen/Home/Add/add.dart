import 'package:flutter/material.dart';
import 'package:food_manager/model/item.dart';
import 'package:food_manager/get/UserController.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:food_manager/get/ProductController.dart';
import 'package:food_manager/screen/Home/Add/add_dialog.dart';
import 'package:food_manager/screen/Home/Add/add_card.dart';
import 'package:get/get.dart';

class Add extends StatefulWidget {
  const Add({ 
    Key? key,
  }) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  
  _AddState();

  final UserController uc = Get.find();
  final CategoryController cc = Get.find();
  final ProductController pc = Get.find();

  List<Item> itemList = [];

  // 아이템 추가하는 함수
  void addItem(Item item) {
    setState(() {
      itemList.add(item);
    });
  }

  // 아이템 제거하는 함수
  void deleteItem(Item item) {
    setState(() {
      itemList = itemList.where((item) => item.id != item.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AddCard 추가버튼
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop()
                      )
                    ),
                    Text(
                      "${cc.selectedCategory} 추가",
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    // AddCard 추가 버튼
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: TextButton.icon(
                          onPressed: () => showDialog(context: context, builder: (context) => AddDialog(itemList: itemList, addItem: addItem)),
                          icon: Icon(Icons.add, color: Colors.green[800]), 
                          label: Text("추가", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
                        ),
                      )
                    ),
                    const SizedBox(height: 10),
                    Column(children: itemList.map((item) => AddCard(item: item, deleteItem: deleteItem)).toList()),
                  ],
                )
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    primary: Colors.green[800]
                  ),
                  onPressed: () {
                    if (itemList.isEmpty) return;
                    pc.addItem(uc.email.value, itemList);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "추가하기",
                    style: TextStyle(fontWeight: FontWeight.bold)
                  )
                ),
              ),
            )
          ],
        )
      )
    );
  }
}
