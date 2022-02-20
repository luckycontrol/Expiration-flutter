import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_manager/api/push_manager.dart';
import 'package:food_manager/get/UserController.dart';
import 'package:food_manager/get/ProductController.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:get/get.dart';
import 'package:food_manager/screen/loading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RemoveAccount extends StatefulWidget {
  RemoveAccount({Key? key}) : super(key: key);

  @override
  State<RemoveAccount> createState() => _RemoveAccountState();
}

class _RemoveAccountState extends State<RemoveAccount> {
  UserController uc = Get.find();

  ProductController pc = Get.find();

  CategoryController cc = Get.find();

  bool isRemove = false;

  void removeAccount() async {
    CollectionReference ref = FirebaseFirestore.instance.collection(uc.email.value);
    FirebaseAuth auth = FirebaseAuth.instance;

    await Future.wait([
      // Firebase 알람 지우기
      ref.doc("alarm").delete(),
      // 서버에 저장된 알람 제거
      pushManager.removeAlarm(uc.email.value),
      // category 제거
      ref.doc("category").delete(),
      // product 제거
      ref.doc("product").delete(),
      // token 제거
      ref.doc("token").delete(),
    ]).then((value) async {
      // cloud storage에 저장된 이미지들 제거 
      await Future.wait(pc.item_list.map((item) async { await firebase_storage.FirebaseStorage.instance.ref("/product/${uc.email.value}/${item.id}.png").delete(); }));

      // UserDocument 수정
      DocumentReference userRef = FirebaseFirestore.instance.collection("UserCollection").doc("UserDocument");
      List users = await userRef.get().then((snapshot) {
        Map<String, dynamic> users = snapshot.data() as Map<String, dynamic>;
        return (users["users"] as List).where((user) => user != uc.email.value).toList();
      });
      await userRef.set({"users": users});

      await uc.setLogin(auth);
      await uc.setDelete(auth);
      await ref.doc("user").delete();
      Get.offAllNamed("/login");
    });
  }

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
      body: isRemove
      ? const Loading()
      : Container(
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
                  showDialog(context: context, builder: (context) => removeAccountDialog(context));
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

  Widget removeAccountDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("계정을 삭제하실건가요?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() { isRemove = true; });
            removeAccount();
          },
          child: const Text(
            "삭제", 
            style: TextStyle(
              fontSize: 16,
              color: Colors.red
            )
          )
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "취소",
            style: TextStyle(
              fontSize: 16
            )
          )
        )
      ]
    );
  }
}