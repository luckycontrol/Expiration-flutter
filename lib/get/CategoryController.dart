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
    update();
  }

  // 카테고리 추가
  addCategory(String email, String newCategory) {
    categories.add(newCategory);
    update();

    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("category");
    ref.set({"categories": categories});
  }

  // 카테고리 수정
  editCategory(String email, String originalCategory, String newCategory) {
    // 원래 카테고리의 인덱스를 구해서 새로운 카테고리 이름으로 바꿔준다.
    int index = categories.indexOf(originalCategory);
    categories[index] = newCategory;

    // 수정하는 카테고리가 현재 선택된 카테고리라면, 현재 선택된 카테고리를 수정된 카테고리로 바꿔준다.
    if (originalCategory == selectedCategory.value) {
      selectedCategory.value = newCategory;
    }
    update();

    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("category");
    ref.set({"categories": categories});
  }

  // 카테고리 삭제
  deleteCategory(String email, String category) {
    // 카테고리 목록에서 해당 카테고리 삭제
    categories.remove(category);
    // 만약 해당 카테고리가 현재 선택된 카테고리라면, 현재 선택된 카테고리를 첫 번째로 변경해준다.
    if (category == selectedCategory.value) {
      selectedCategory.value = category;
    }
    update();

    // cloud firestore의 category에서 카테고리 삭제
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("category");
    ref.set({"categories": categories});
  }
}