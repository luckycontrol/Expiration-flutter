import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditList extends StatefulWidget {

  String selectedCategory;
  List<String> categories;
  void Function(String) editMainSelectedCategory;
  void Function(String) editMenuSelectedCategory;
  void Function(int, String) editMenuCategory;

  EditList({ 
    required this.selectedCategory,
    required this.editMainSelectedCategory,
    required this.categories,
    required this.editMenuSelectedCategory,
    required this.editMenuCategory,
  });

  @override
  _EditListState createState() => _EditListState(
    selectedCategory: selectedCategory,
    categories: categories,
    editMainSelectedCategory: editMainSelectedCategory,
    editMenuSelectedCategory: editMenuSelectedCategory,
    editMenuCategory: editMenuCategory,
  );
}

class _EditListState extends State<EditList> {

  String selectedCategory;
  List<String> categories;
  void Function(String) editMainSelectedCategory;
  void Function(String) editMenuSelectedCategory;
  void Function(int, String) editMenuCategory;

  _EditListState({ 
    required this.selectedCategory,
    required this.categories,
    required this.editMainSelectedCategory,
    required this.editMenuSelectedCategory,
    required this.editMenuCategory
  });

  void editListCategory(int idx, String category) {
    setState(() {
      categories[idx] = category;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        onPressed: (context) {
                          setState(() {
                            categories.remove(category);
                          });
                        },
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
                int idx = categories.indexOf(category);
                editMenuCategory(idx, newCategoryName);
                editListCategory(idx, newCategoryName);
                if (category == selectedCategory) {
                  editMenuSelectedCategory(newCategoryName);
                  editMainSelectedCategory(newCategoryName);
                }

                Navigator.of(context).pop();
              },
            )
          ],
        )
      )
    );
  }
}