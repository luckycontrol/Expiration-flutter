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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {

  final ProductController pc = Get.put(ProductController());
  final CategoryController cc = Get.put(CategoryController());
  final UserController uc = Get.put(UserController());
  
  late AppLifecycleState _appLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    
    // initialize
    void init() async {
      String _email = FirebaseAuth.instance.currentUser!.email!;

      // 토큰 저장
      String? token = await FirebaseMessaging.instance.getToken();
      DocumentReference ref = FirebaseFirestore.instance.collection(_email).doc("token");
      await ref.set({"token": token});

      await uc.setEmail(_email);
      await uc.setNickname(_email);
      await cc.initialize(_email);
      await pc.initialize(_email);
    }

    init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });

    if (_appLifecycleState.index == 0) {
      pc.initialize(uc.email.value);
    }
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
      body: RefreshIndicator(
        onRefresh: () => pc.initialize(uc.email.value),
        child: GetBuilder<ProductController>(
          builder: (product) => GetBuilder<CategoryController>(
            builder: (category) => product.loading.value
            ? const Loading()
            : ListView(
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