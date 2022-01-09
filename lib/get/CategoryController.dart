import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  List<String> categories = <String>[].obs;
  var selectedCategory = "".obs;

  // 카테고리 initialize
  initialize(email) async {
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("category");

    List<String> _categories = await ref
    .get()
    .then((snapshot) {
      Map<String, dynamic> _categories = snapshot.data() as Map<String, dynamic>;
      return (_categories["categories"] as List).map((item) => item as String).toList();
    });

    categories = _categories;
    selectedCategory.value = _categories[0];
  }

  // 카테고리 선택
  selectCategory(String newCategory) {
    selectedCategory.value = newCategory;
  }

  // 카테고리 추가
  // 카테고리 수정
  // 카테고리 삭제
}