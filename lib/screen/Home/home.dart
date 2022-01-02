import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Expire/expire_list.dart';
import 'package:food_manager/screen/Home/Item/item_list.dart';
import 'package:food_manager/screen/Home/Menu/menu.dart';
import 'package:food_manager/screen/Home/Add/add.dart';
import 'package:food_manager/model/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

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

  // 선택 카테고리 변경
  void editMainSelectedCategory(String selectCategory) {
    setState(() {
      selectedCategory = selectCategory;
    });
  }

  // 품목 추가
  void addItem(Item item) async {
    setState(() {
      item_list.add(item);
    });

    var items = item_list.map((i) {
      return i.toJson();
    }).toList();

    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    ref.set({"product": items});
    
    // for (Item i in item_list) {
    //   try {
    //     firebase_storage.FirebaseStorage.instance.ref("product/$email/${i.id}.png").putFile(File(i.image.path));
    //   } on FirebaseException catch(e) {
    //     print(e);
    //   }
    // }
  }
  // 품목 삭제
  void removeItem(Item removeItem) {
    setState(() {
      item_list = item_list.where((item) => item.id != removeItem.id).toList();
    });
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    ref.set({"product": item_list});
  }
  // 품목 수정
  void editItem(Item editItem) {
    item_list = item_list.where((item) => item.id != editItem.id).toList();
    setState(() {
      item_list.add(editItem);
    });
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    ref.set({"product": item_list});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    void init() async {
      String _email = FirebaseAuth.instance.currentUser!.email!;
      DocumentReference userRef = FirebaseFirestore.instance.collection(_email).doc("user");
      DocumentReference categoryRef = FirebaseFirestore.instance.collection(_email).doc("category");
      DocumentReference productRef = FirebaseFirestore.instance.collection(_email).doc("product");
      
      userRef.get().then((snapshot) {
        Map<String, dynamic> _nickname = snapshot.data() as Map<String, dynamic>;
        setState(() {
          email = _email;
          nickname = _nickname["nickname"];
        });
      });

      categoryRef.get().then((snapshot) {
        Map<String, dynamic> _categories = snapshot.data() as Map<String, dynamic>;
        setState(() {
          categories = (_categories["categories"] as List).map((item) => item as String).toList();
          selectedCategory = categories[0];
        });
      });

      productRef.get().then((snapshot) {
        Map<String, dynamic> _product = snapshot.data() as Map<String, dynamic>;
        List<Item> _item_list = (_product["product"] as List).map((item) => Item.fromJson(item)).toList();
        setState(() {
          item_list = _item_list;
        });
      });
      
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