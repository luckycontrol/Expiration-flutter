import 'package:flutter/material.dart';
import 'package:food_manager/screen/Utils/alert_dialog.dart';
import 'package:food_manager/screen/loading.dart';
import 'package:food_manager/api/push_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({ Key? key }) : super(key: key);

  @override
  _CreateAccountState createState()   => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  String email = "";
  String nickname = "";
  String password = "";
  bool loading = false;

  Map<String, String> messages = {
    "invalid-email": "이메일 형식으로 입력해주세요.",
    "weak-password": "비밀번호를 6자리 이상으로 입력해주세요.",
    "email-already-in-use": "입력하신 이메일이 이미 사용되고 있습니다."
  };

  void handleCreateAccount(String email, String nickname, String password) async {
    if (email == "") {
      showDialog(context: context, builder: (context) => AlertMessageDialog(message: "이메일을 입력해주세요."));
      return;
    }

    if (nickname == "") {
      showDialog(context: context, builder: (context) => AlertMessageDialog(message: "이름 / 별명을 입력해주세요."));
      return;
    }

    if (password == "") {
      showDialog(context: context, builder: (context) => AlertMessageDialog(message: "비밀번호를 입력해주세요."));
      return;
    }

    try {
      setState(() { loading = true; });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // 카테고리 저장
      CollectionReference ref = FirebaseFirestore.instance.collection(email);
      await ref
            .doc("category")
            .set({"categories": ["정육", "채소", "생선"]});
      // 닉네임 저장
      await ref.doc("user").set({"nickname": nickname});
      // 알람 저장
      await ref.doc("alarm").set({"alarm": DateTime(1961, 3, 3, 7)});

      // 토큰 저장
      String? token = await FirebaseMessaging.instance.getToken();
      await ref.doc("token").set({"token": token });
      // 알람설정
      await PushManager().setAlarm(email, DateTime(1969, 3, 3, 7));

      // UserCollection > UserDocument에 이메일 추가
      DocumentReference userCollectionRef = FirebaseFirestore.instance.collection("UserCollection").doc("UserDocument");
      List<String> users = await userCollectionRef
      .get()
      .then((snapshot) {
        if (!snapshot.exists) return [];

        Map<String, dynamic> _users = snapshot.data() as Map<String, dynamic>;
        return (_users["users"] as List).map((user) => user as String).toList();
      });

      users.add(email);
      userCollectionRef.set({"users": users});
      Get.offAllNamed("/home");

    } on FirebaseAuthException catch(e) {
      String errMessage = messages[e.code]!;
      showDialog(context: context, builder: (context) => AlertMessageDialog(message: errMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정생성'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5
      ),
      body: SafeArea(
        child: loading
          ? const Loading()
          : Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  '유통기한 관리사',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text("아이디", style: TextStyle(color: Colors.green[800])),
                          hintText: "이메일 형식으로 입력해주세요.",
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                            )
                        ),
                        onChanged: (value) { email = value; },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text("이름 / 별명", style: TextStyle(color: Colors.green[800])),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                            )
                        ),
                        onChanged: (value) { nickname = value; },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text("비밀번호", style: TextStyle(color: Colors.green[800])),
                          hintText: "6자 이상으로 입력해주세요.",
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                            )
                        ),
                        onChanged: (value) { password = value; }
                      )
                    ],
                  ),
                ),
                // FIXME: 생성버튼
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    primary: Colors.green
                  ),
                  onPressed: () { 
                    handleCreateAccount(email, nickname, password);
                  }, 
                  child: const Text('계정 생성')
                )
              ],
            ),
          )
        ),
      )
    );
  }
}