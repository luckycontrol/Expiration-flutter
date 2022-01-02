import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_manager/screen/Account/login.dart';
import 'package:food_manager/screen/Home/Menu/menu_card.dart';
import 'package:food_manager/screen/Home/Option/option.dart';
import 'package:food_manager/screen/Utils/alert_dialog.dart';
import 'package:food_manager/screen/Home/Menu/edit_list.dart';

class Menu extends StatefulWidget {
  Menu({ 
    Key? key,
    required this.email,
    required this.nickname,
    required this.categories, 
    required this.selectedCategory,
    required this.editMainSelectedCategory
  }) : super(key: key);

  String email;
  String nickname;
  List<String> categories;
  String selectedCategory;
  void Function(String) editMainSelectedCategory;

  @override
  State<Menu> createState() => _MenuState(
    email: email,
    nickname: nickname,
    categories: categories, 
    selectedCategory: selectedCategory,
    editMainSelectedCategory: editMainSelectedCategory
  );
}

class _MenuState extends State<Menu> {

  String email;
  String nickname;
  List<String> categories;
  String selectedCategory;
  void Function(String) editMainSelectedCategory;

  bool isEdit = false;
  bool isDelete = false;
  String deleteCategoryName = "";

  _MenuState({
    required this.email,
    required this.nickname,
    required this.categories, 
    required this.selectedCategory,
    required this.editMainSelectedCategory,
  });

  // FIXME: 카테고리 공백, 중복 체크
  bool check_category_null_duplicate(String elem) {
    if (elem == "") {
      showDialog(context: context, builder: (context) => AlertMessageDialog(message: "카테고리 이름을 기입해주세요!"));
      return false;
    }

    if (categories.contains(elem)) {
      showDialog(context: context, builder: (context) => AlertMessageDialog(message: "입력하신 카테고리가 이미 있어요!"));
      return false;
    }

    return true;
  }

  // FIXME: 메뉴화면 선택된 카테고리 수정
  void editMenuSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  // FIXME: 메뉴화면 카테고리 수정
  void editMenuCategory(int idx, String category) {
    setState(() {
      categories[idx] = category;
    });
  }

  // FIXME: 카테고리 추가
  void addCategory(String category) {
    setState(() {
      categories.add(category);
    });
  }

  // FIXME: 카테고리 삭제
  void removeCategory(String category) {
    setState(() {
      categories.remove(category);
    });
  }
  
  // FIXME: 로그아웃
  void handleSignOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        height: size.height,
        color: Colors.green[800],
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FIXME: 인사 문구
                  Text(
                    '안녕하세요, \n$nickname님.',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.white,
                    )
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("카테고리", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // FIXME: 카테고리 추가 버튼
                              TextButton.icon(
                                onPressed: () => showDialog(context: context, builder: buildAddModal), 
                                icon: const Icon(Icons.add, size: 20, color: Colors.white), 
                                label: const Text(
                                  '추가',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )
                                )
                              ),
                              // FIXME: 카테고리 수정 버튼
                              TextButton.icon(
                                onPressed: () => showModalBottomSheet(context: context, builder: (context) => EditList(
                                    categories: categories, 
                                    selectedCategory: selectedCategory,
                                    editMainSelectedCategory: editMainSelectedCategory,
                                    editMenuSelectedCategory: editMenuSelectedCategory,
                                    editMenuCategory: editMenuCategory,
                                    removeCategory: removeCategory,
                                  )
                                ), 
                                icon: const Icon(Icons.edit, size: 20, color: Colors.white), 
                                label: const Text(
                                  '수정',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  )
                                )
                              ),
                            ],
                          )
                        ],
                      ),
                      // FIXME: 저장된 카테고리 목록
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: categories.map((menu) => MenuCard(
                          name: menu,
                          isEdit: isEdit,
                          selectedCategory: selectedCategory,
                          editMainSelectedCategory: editMainSelectedCategory,
                        )).toList(),
                      ),
                      const SizedBox(height: 20.0),
                      // FIXME: 설정
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FIXME: 설정 버튼
                          GestureDetector(
                            child: Row(
                              children: const [
                                Icon(Icons.settings, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "설정",
                                  style: TextStyle(
                                    color: Colors.white, 
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  )
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Option()));
                            }
                          ),
                          const SizedBox(height: 20),
                          // FIXME: 로그아웃 버튼
                          GestureDetector(
                            child: Row(
                              children: const [
                                Icon(Icons.logout, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "로그아웃",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  )
                                )
                              ],
                            ),
                            onTap: () {
                              handleSignOut();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
                            }
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ),
        ),
      )
    );
  }

  // FIXME: 카테고리 추가
  Widget buildAddModal(BuildContext context) {

    String newCategoryName = "";

    return AlertDialog(
      title: Text("카테고리 추가"),
      content: Container(
        height: 200,
        child: Column(
          children: [
            // FIXME: 카테고리 이름 인풋필드
            TextField(
              decoration: InputDecoration(
                label: Text("카테고리 이름", style: TextStyle(color: Colors.green[800])),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)
                )
              ),
              onChanged: (value) { setState(() { newCategoryName = value; }); }
            ),
            const Spacer(),
            // FIXME: 카테고리 추가 버튼
            ElevatedButton(
              child: const Text("추가하기"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                primary: Colors.green[800]
              ),
              onPressed: () {
                newCategoryName = newCategoryName.trim();
                bool result = check_category_null_duplicate(newCategoryName);

                if (result) {
                  addCategory(newCategoryName);
                  Navigator.of(context).pop();
                }
              }
            )
          ],
        )
      )
    );
  }
}
