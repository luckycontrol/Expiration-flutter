import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_manager/get/UserController.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:food_manager/get/ProductController.dart';
import 'package:get/get.dart';

class EditList extends StatefulWidget {

  EditList();

  @override
  _EditListState createState() => _EditListState();
}

class _EditListState extends State<EditList> {

  final UserController uc = Get.find();
  final CategoryController cc = Get.find();
  final ProductController pc = Get.find();

  _EditListState();

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
            GetBuilder<CategoryController>(
              builder: (_) => Column(
                children: _.categories.map((category) {
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
                            // 카테고리 삭제
                            _.deleteCategory(uc.email.value, category);
                            // 해당 카테고리 내 모든 품목 제거
                            if (pc.item_list.where((item) => item.category == category).toList().isNotEmpty) {
                              pc.removeItems(uc.email.value, category);
                            }
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
              child: const Text("수정하기"),
              onPressed: () {
                // category controller에서 카테고리 수정
                cc.editCategory(uc.email.value, category, newCategoryName);
                // product controller에서 아이템 카테고리를 수정된 카테고리로 변경
                if (pc.item_list.where((item) => item.category == category).toList().isNotEmpty ){
                  pc.editItems(uc.email.value, category, newCategoryName);
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