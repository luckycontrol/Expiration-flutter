import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Menu/menu_card.dart';
import 'package:food_manager/screen/Home/Option/option.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Menu extends StatefulWidget {
  Menu({ 
    Key? key, 
    required this.categories, 
    required this.selectedCategory,
    required this.addCategory,
    required this.changeCategory 
  }) : super(key: key);

  List<String> categories;
  String selectedCategory;
  void Function(String) addCategory;
  void Function(String) changeCategory;

  @override
  State<Menu> createState() => _MenuState(
    categories: categories, 
    selectedCategory: selectedCategory, 
    addCategory: addCategory,
    changeCategory: changeCategory
  );
}

class _MenuState extends State<Menu> {

  List<String> categories;
  String selectedCategory;
  void Function(String) addCategory;
  void Function(String) changeCategory;

  bool isEdit = false;
  bool isDelete = false;
  String deleteCategoryName = "";

  _MenuState({ 
    required this.categories, 
    required this.selectedCategory,
    required this.addCategory, 
    required this.changeCategory 
  });

  // FIXME: 카테고리 공백, 중복 체크
  bool check_category_null_duplicate(String elem) {
    if (elem == "") {
      showDialog(context: context, builder: (context) => buildCategoryCheckModal("카테고리 이름을 기입해주세요!"));
      return false;
    }

    if (categories.contains(elem)) {
      showDialog(context: context, builder: (context) => buildCategoryCheckModal("입력하신 카테고리가 이미 있어요!"));
      return false;
    }

    return true;
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
                  const Text(
                    '안녕하세요, \n종운님.',
                    style: TextStyle(
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
                                onPressed: () => showModalBottomSheet(context: context, builder: buildEditModal), 
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
                          changeCategory: changeCategory
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
                            onTap: () {}
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
              onChanged: (value) { 
                setState(() {
                  newCategoryName = value;
                });
              }
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

  // FIXME: 카테고리 수정 리스트
  Widget buildEditModal(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 2.5,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // FIXME: 카테고리 수정 텍스트
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "카테고리 수정 (항목을 슬라이드해보세요!)", 
                  style: TextStyle(
                    fontSize: 18.0, 
                    fontWeight: FontWeight.bold
                  )
                ),
              )
            ),
            // FIXME: 카테고리 목록
            Column(
              children: categories.map((category) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      // FIXME: 카테고리 수정 버튼
                      SlidableAction(
                        label: "수정",
                        onPressed: (context) => showDialog(context: context, builder: (context) => EditCategoryWidget(context, category)),
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                      ),
                      // FIXME: 카테고리 삭제 버튼
                      SlidableAction(
                        label: "삭제",
                        onPressed: (context) { setState(() { categories.remove(category); }); },
                        backgroundColor: Colors.red[400]!,
                        foregroundColor: Colors.white,
                      )
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!
                        )
                      )
                    ),
                    child: Row(
                      children: [
                        Text(category)
                      ],
                    )
                  )
                );
              }).toList(),
            )
          ],
        )
      )
    );
  }

  // FIXME: 카테고리 수정 위젯
  Widget EditCategoryWidget(BuildContext context, String category) {

    Size size = MediaQuery.of(context).size;
    String newCategoryName = category;

    return AlertDialog(
      title: Text("$category 수정"),
      content: Container(
        height: size.height / 4,
        child: Column(
          children: [
            // FIXME: 카테고리 이름 입력 인풋필드
            TextFormField(
              initialValue: category,
              autocorrect: false,
              cursorColor: Colors.green[800],
              decoration: InputDecoration(
                label: Text("카테고리 이름", style: TextStyle(color: Colors.green[800])),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)
                )
              ),
              onChanged: (value) { 
                setState(() { newCategoryName = value; });
              },
            ),
            const Spacer(),
            // FIXME: 수정하기 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                primary: Colors.green[800]
              ),
              child: Text("수정하기"),
              onPressed: () {
                newCategoryName = newCategoryName.trim();
                bool result = check_category_null_duplicate(newCategoryName);

                if (result) {
                  int index = categories.indexOf(category);

                  if (selectedCategory == category) {
                    changeCategory(newCategoryName);
                  }
                  setState(() {
                    if (selectedCategory == category) {
                      selectedCategory = newCategoryName;
                    }
                    categories[index] = newCategoryName;
                  });
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        )
      )
    );
  }

  // FIXME: 중복, 공백 체크 모달
  Widget buildCategoryCheckModal(String message) {
    return AlertDialog(
      title: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red[300],
    );
  }
}
