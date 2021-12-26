import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Expire/expire_list.dart';
import 'package:food_manager/screen/Home/Item/item_list.dart';
import 'package:food_manager/screen/Home/Menu/menu.dart';
import 'package:food_manager/screen/Home/Add/add.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String selectedCategory = "정육";

  void changeCategory(String selectCategory) {
    setState(() {
      selectedCategory = selectCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Menu(selectedCategory: selectedCategory, changeCategory: changeCategory)
      ),
      appBar: AppBar(
        title: Text(selectedCategory),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // 추가 아이콘
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Add(selectedCategory: selectedCategory)))
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // FIXME: 유통기한이 곧 끝나가는 품목들
            ExpireList(),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              // FIXME: 카테고리에 저장된 품목들 목록
              child: ItemList(),
            ),
          ],
        ),
      )
    );
  }
}