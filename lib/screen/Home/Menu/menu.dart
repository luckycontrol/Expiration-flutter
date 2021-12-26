import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Menu/menu_card.dart';

class Menu extends StatefulWidget {
  Menu({ Key? key, required this.selectedCategory, required this.changeCategory }) : super(key: key);

  String selectedCategory;
  void Function(String) changeCategory;

  @override
  State<Menu> createState() => _MenuState(selectedCategory: selectedCategory, changeCategory: changeCategory);
}

class _MenuState extends State<Menu> {

  String selectedCategory;
  void Function(String) changeCategory;

  bool isClicked = false;
  List<String> menus = ['정육', '채소', '생선'];

  _MenuState({ required this.selectedCategory, required this.changeCategory });

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
                              TextButton.icon(
                                onPressed: () {
                                }, 
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
                              TextButton.icon(
                                onPressed: () {}, 
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
                      // 저장된 카테고리들
                      Column(
                        children: menus.map((menu) => MenuCard(name: menu, selectedCategory: selectedCategory, changeCategory: changeCategory)).toList(),
                      ),
                      const SizedBox(height: 20.0),
                      TextButton.icon(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () => Navigator.pushNamed(context, "/home/option"),
                        label: const Text(
                          "설정",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),
                      const SizedBox(height: 20.0),
                      TextButton.icon(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () {},
                        label: const Text(
                          "로그아웃",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          )
                        )
                      )
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
}
