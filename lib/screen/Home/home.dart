import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Expire/expire_list.dart';
import 'package:food_manager/screen/Home/Item/item_list.dart';
import 'package:food_manager/screen/Home/Menu/menu.dart';
import 'package:food_manager/screen/Home/Add/add.dart';
import 'package:food_manager/get/ProductController.dart';
import 'package:food_manager/get/UserController.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:food_manager/screen/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final ProductController pc = Get.put(ProductController());
  final CategoryController cc = Get.put(CategoryController());
  final UserController uc = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    
    // initialize
    void init() async {
      String _email = FirebaseAuth.instance.currentUser!.email!;

      await uc.setEmail(_email);
      await uc.setNickname(_email);
      await cc.initialize(_email);
      await pc.initialize(_email);
    }

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Menu()
      ),
      appBar: AppBar(
        title: Obx(() => Text(cc.selectedCategory.value)),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          // 추가 아이콘
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Add()))
          )
        ],
      ),
      body: GetBuilder<ProductController>(
        builder: (product) => GetBuilder<CategoryController>(
          builder: (category) => product.loading.value
          ? const Loading()
          : SingleChildScrollView(
            child: Column(
              children: [
                ExpireList(expire_soon_list: product.item_list.where((item) => DateTime.now().day + 3 >= item.expiration.day).toList()),
                ItemList(item_list: product.item_list.where((item) => item.category == category.selectedCategory.value).toList()),
              ],
            ),
          )
        ) 
      )
    );
  }
}