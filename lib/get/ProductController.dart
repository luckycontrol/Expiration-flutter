import 'dart:io';
import 'package:get/get.dart';
import 'package:food_manager/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductController extends GetxController {
  List<Item> item_list = <Item>[].obs;
  RxBool loading = RxBool(false);

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
    update();
  }

  // 아이템 추가
  addItem(String email, List<Item> itemList) async {
    loading.value = true;
    update();

    for (Item item in itemList) {
      try {
        await firebase_storage.FirebaseStorage.instance.ref("product/$email/${item.id}.png").putFile(File(item.image));
        String imgURL = await  firebase_storage.FirebaseStorage.instance.ref("product/$email/${item.id}.png").getDownloadURL();

        Item _item = Item(
          id: item.id,
          name: item.name,
          category: item.category,
          expiration: item.expiration,
          image: imgURL
        );

        item_list.add(_item);
      } on FirebaseException catch(e) {
        print(e);
      }
    }

    loading.value = false;
    update();

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

  // 아이템 수정
  editItem(String email, Item editItem, bool isChanged) async {
    loading.value = true;
    update();
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
    item_list.add(_item);
    loading.value = false;
    update();

    // 아이템 리스트를 json으로 변경
    List<Map<String, dynamic>> _item_list = item_list.map((_item) => _item.toJson()).toList();

    // firestore에 json 저장
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    ref.set({"product": _item_list });
  }

  // 아이템 삭제
  removeItem(String email, Item removeItem) {
    item_list = item_list.where((item) => item.id != removeItem.id).toList();
    update();
    
    // cloud firestore에 저장
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    List<Map<String, dynamic>> _item_list = item_list.map((_item) => _item.toJson()).toList();
    ref.set({"product": _item_list});

    // 이미지 삭제
    try {
      firebase_storage.FirebaseStorage.instance.ref("product/$email/${removeItem.id}.png").delete();
    } on FirebaseException catch(e) {
      print(e);
    }
  }

  // 카테고리 수정 ( 여러 아이템 한 번에 수정 )
  editItems(String email, String category, String newCategory) {
    // 아이템 리스트를 순회하면서 카테고리 이름을 바꿔준다.
    item_list = item_list.map((item) {
      if (item.category == category) {
        Item newItem = Item(
          id: item.id,
          name: item.name,
          category: newCategory,
          expiration: item.expiration,
          image: item.image
        );

        return newItem;
      } else {
        return item;
      }
    }).toList();

    // 수정된 리스트를 cloud firestore에 저장해준다.
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    List<Map<String, dynamic>> _item_list = item_list.map((item) => item.toJson()).toList();
    ref.set({"product": _item_list});
  }

  // 카테고리 삭제 ( 여러 아이템 한 번에 삭제 )
  removeItems(String email, String category) {
    // 제거할 아이템들만 수집
    List<Item> deleteItems = item_list.where((item) => item.category == category).toList();

    // 아이템 목록에서 해당 카테고리 아이템들 제거
    item_list = item_list.where((item) => item.category != category).toList();
    update();

    // cloud firestore에 변경된 아이템목록 반영
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("product");
    List<Map<String, dynamic>> _item_list = item_list.map((_item) => _item.toJson()).toList();
    ref.set({"product": _item_list});

    // cloud storege에 이미지들 제거
    try {
      for (Item i in deleteItems) {
        firebase_storage.FirebaseStorage.instance.ref("product/$email/${i.id}.png").delete();
      }
    } on FirebaseException catch(e) {
      print(e);
    }
  }
}