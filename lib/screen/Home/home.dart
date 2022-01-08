import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Expire/expire_list.dart';
import 'package:food_manager/screen/Home/Item/item_list.dart';
import 'package:food_manager/screen/Home/Menu/menu.dart';
import 'package:food_manager/screen/Home/Add/add.dart';
import 'package:food_manager/model/item.dart';
import 'package:food_manager/get/ProductController.dart';
import 'package:food_manager/get/UserController.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String email = "";
  String nickname = "";
  String selectedCategory = "";
  List<String> categories = [];
  List<Item> expire_soon_list = [];
  List<Item> item_list = [];

  final ProductController pc = Get.put(ProductController());
  final CategoryController cc = Get.put(CategoryController());
  final UserController uc = Get.put(UserController());

  // 선택 카테고리 변경
  void editMainSelectedCategory(String selectCategory) {
    setState(() {
      selectedCategory = selectCategory;
    });
  }

  // 품목 삭제
  void removeItem(Item removeItem) {
    setState(() {
      item_list = item_list.where((item) => item.id != removeItem.id).toList();
    });

    List<Map<String, dynamic>> _item_list = item_list.map((_item) {
      ItemExchange _itemExchange = ItemExchange(
        id: _item.id,
        name: _item.name,
        category: _item.category,
        expiration: _item.expiration
      );

      return _itemExchange.toJson();
    }).toList();

    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    ref.set({"product": _item_list});
    try {
      firebase_storage.FirebaseStorage.instance.ref("product/$email/${removeItem.id}").delete();
    } on FirebaseException catch(e) {
      print(e);
    }
  }
  // 품목 수정
  void editItem(Item editItem, bool isChanged) async {
    if (isChanged) {
      // cloud storage에 이미지 저장
      try {
        await firebase_storage.FirebaseStorage.instance.ref("product/$email/${editItem.id}.png").putFile(File(editItem.image));
      } on FirebaseException catch(e) {
        print(e);
      }
    }

    // cloud storage의 이미지 경로 로드
    String imgURL = isChanged ? await firebase_storage.FirebaseStorage.instance.ref("product/$email/${editItem.id}.png").getDownloadURL() : editItem.image;
    // 새로운 Item 생성
    Item _item = Item(
      id: editItem.id,
      name: editItem.name,
      category: editItem.category,
      expiration: editItem.expiration,
      image: imgURL
    );

    // 기존 리스트에서 수정된 아이템 삭제
    item_list = item_list.where((item) => item.id != editItem.id).toList();

    // 기존 아이템 리스트에 수정된 아이템 추가
    setState(() {
      item_list.add(_item);
    });

    // 아이템 리스트를 json으로 변경
    List<Map<String, dynamic>> _item_list = item_list.map((_item) => _item.toJson()).toList();

    // firestore에 json 저장
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    ref.set({"product": _item_list});
  }

  @override
  void initState() {
    super.initState();
    
    // initialize
    void init() async {
      String _email = FirebaseAuth.instance.currentUser!.email!;

      await uc.setEmail(_email);
      await uc.setNickname();
      await cc.initialize(_email);
      await pc.initialize(_email);
    }

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Menu(
          email: email,
          nickname: nickname,
          categories: categories, 
          selectedCategory: selectedCategory,
          editMainSelectedCategory: editMainSelectedCategory,
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Add(selectedCategory: selectedCategory)))
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // FIXME: 유통기한이 곧 끝나가는 품목들
            ExpireList(
              expire_soon_list: pc.item_list.where((item) {
                DateTime now = DateTime.now();
                DateTime beforeAthree = now.add(const Duration(days: 3));
                return item.expiration.isBefore(beforeAthree);
              }).toList()
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              // FIXME: 카테고리에 저장된 품목들 목록
              child: ItemList(
                item_list: pc.item_list.where((item) => item.category == selectedCategory).toList(), 
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