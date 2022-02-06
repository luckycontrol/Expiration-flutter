import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_manager/api/push_manager.dart';
import 'package:food_manager/get/UserController.dart';
import 'package:food_manager/get/ProductController.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:get/get.dart';

class RemoveAccount extends StatelessWidget {
  RemoveAccount({Key? key}) : super(key: key);

  UserController uc = Get.find();
  ProductController pc = Get.find();
  CategoryController cc = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원탈퇴"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: const [
                    Text(
                      "사용해주셔서 감사합니다.",
                      style: TextStyle(
                        fontSize: 20,
                      )
                    ),
                  ],
                )
              )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width, 50),
                primary: Colors.green[800]
              ),
              onPressed: () async {
                try {
                  // 이메일에 저장된 품목들 삭제
                  cc.categories.map((category) => {
                   pc.removeItems(uc.email.value, category)
                  });
                  // UserCollection -> UserDocument에서 삭제
                  DocumentReference ref = FirebaseFirestore.instance.collection("UserCollection").doc("UserDocument");
                  List<String> users = await ref.get().then((snapshot) {
                    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
                    List<String> users = (data["users"] as List).map((user) => user as String).toList();
                    return users.where((user) => user != uc.email.value).toList();
                  });

                  await ref.set({"users": users});
                  await FirebaseFirestore.instance.collection(uc.email.value).doc("alarm").delete();
                  await FirebaseFirestore.instance.collection(uc.email.value).doc("category").delete();
                  await FirebaseFirestore.instance.collection(uc.email.value).doc("product").delete();
                  await FirebaseFirestore.instance.collection(uc.email.value).doc("token").delete();
                  await FirebaseFirestore.instance.collection(uc.email.value).doc("user").delete();
                  await PushManager().removeAlarm(uc.email.value);
                  // FirebaseAuth에서 계정 삭제
                  await FirebaseAuth.instance.currentUser!.delete();
                  Get.offAllNamed('/login');
                  
                } on FirebaseException catch (e) {
                  print(e);
                }
              },
              child: const Text("계정삭제", style: TextStyle(fontWeight: FontWeight.bold))
            ),
            const SizedBox(height: 15)
          ],
        ) 
      )
    );
  }
}