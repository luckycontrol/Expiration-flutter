import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Expire/expire_list.dart';
import 'package:food_manager/screen/Home/Item/item_list.dart';
import 'package:food_manager/screen/Home/Menu/menu.dart';
import 'package:food_manager/screen/Home/Add/add.dart';
import 'package:food_manager/model/item.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String selectedCategory = "정육";
  List<String> categories = ["정육", "생선", "과일"];

  List<Item> expire_soon_list = [

  ];

  List<Item> item_list = [

  ];

  // 삭제 확인 State
  bool isDelete = false;

  // 선택 카테고리 변경
  void changeCategory(String selectCategory) {
    setState(() {
      selectedCategory = selectCategory;
    });
  }
  // 카테고리 추가
  void addCategory(String newCategoryName) {
    setState(() {
      categories.add(newCategoryName);
    });
  }
  // 카테고리 삭제
  void removeCategory(String categoryName) {
    setState(() {
      categories.remove(categoryName);
    });
  }
  // 카테고리 수정
  void editCategory(String originalName, String newName) {
    categories.remove(originalName);

    setState(() {
      categories.add(newName);

      for (var item in item_list) {
        if (item.category == originalName) {
          item.category = newName;
        }
      }
    });
  }

  // 품목 추가
  void addItem(Item item) {
    setState(() {
      item_list.add(item);
    });
  }
  // 품목 삭제
  void removeItem(Item removeItem) {
    setState(() {
      item_list = item_list.where((item) => item.id != removeItem.id).toList();
    });
  }
  // 품목 수정
  void editItem(Item editItem) {
    item_list = item_list.where((item) => item.id != editItem.id).toList();
    setState(() {
      item_list.add(editItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Menu(
          categories: categories, 
          selectedCategory: selectedCategory, 
          addCategory: addCategory, 
          changeCategory: changeCategory
        )
      ),
      appBar: AppBar(
        title: Text(selectedCategory),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: expire_soon_list.isNotEmpty ? 0 : 1,
        actions: [
          // 추가 아이콘
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Add(selectedCategory: selectedCategory, addItem: addItem)))
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // FIXME: 유통기한이 곧 끝나가는 품목들
            if (expire_soon_list.isNotEmpty) ExpireList(expire_soon_list: expire_soon_list),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              // FIXME: 카테고리에 저장된 품목들 목록
              child: ItemList(
                item_list: item_list.where((item) => item.category == selectedCategory).toList(), 
                categories: categories,
                editItem: editItem,
                removeItem: removeItem
              )
            ),
          ],
        ),
      )
    );
  }
}