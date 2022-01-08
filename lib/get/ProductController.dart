import 'dart:io';
import 'package:get/get.dart';
import 'package:food_manager/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductController extends GetxController {
  List<Item> item_list = <Item>[].obs;

  // initialize
  initialize(String email) async {
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");

    List<Item> _item_list = await ref
    .get()
    .then((snapshot) {
      if (!snapshot.exists) return [];

      Map<String, dynamic> _product = snapshot.data() as Map<String, dynamic>;
      return (_product["product"] as List).map((_item) => Item.fromJson(_item)).toList();
    });

    item_list = _item_list;
  }

  // 아이템 추가
  addItem(String email, Item item) async {
    try {
      await firebase_storage.FirebaseStorage.instance.ref("product/$email/${item.id}.png").putFile(File(item.image));
    } on FirebaseException catch(e) {
      print(e);
    }

    String imgURL = await  firebase_storage.FirebaseStorage.instance.ref("product/$email/${item.id}.png").getDownloadURL();

    Item _item = Item(
      id: item.id,
      name: item.name,
      category: item.category,
      expiration: item.expiration,
      image: imgURL
    );

    item_list.add(_item);

    List<Map<String, dynamic>> _item_list = item_list.map((_item) {
      Item _itemExchange = Item(
        id: _item.id,
        name: _item.name,
        category: _item.category,
        expiration: _item.expiration,
        image: _item.image
      );

      return _itemExchange.toJson();
    }).toList();

    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    ref.set({"product": _item_list });
  }
}