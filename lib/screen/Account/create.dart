import 'package:flutter/material.dart';
import 'package:food_manager/screen/Utils/alert_dialog.dart';
import 'package:food_manager/screen/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({ Key? key }) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  String email = "";
  String nickname = "";
  String password = "";

  Map<String, String> messages = {
    "invalid-email": "이메일 형식으로 입력해주세요.",
    "weak-password": "비밀번호를 6자리 이상으로 입력해주세요.",
    "email-already-in-use": "입력하신 이메일이 이미 사용되고 있습니다."
  };

  @override
  Widget build(BuildContext context) {

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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        // FIXME: 카테고리 initialize
        CollectionReference ref = FirebaseFirestore.instance.collection(email);
        await ref
              .doc("category")
              .set({"categories": ["정육", "채소", "생선"]})
              .then((value) { Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home())); })
              .catchError((error) { print(error); });

        // FIXME: 토큰 저장
        String? token = await FirebaseMessaging.instance.getToken();
        DocumentReference docRef = FirebaseFirestore.instance.collection(email).doc("token");
        docRef.set({"token": token });

        // FIXME: UserCollection > UserDocument에 이메일 추가
        DocumentReference userCollectionRef = FirebaseFirestore.instance.collection("UserCollection").doc("UserDocument");
        List<String> users = await userCollectionRef
        .get()
        .then((snapshot) {
          if (!snapshot.exists) return [];

          Map<String, dynamic> _users = snapshot.data() as Map<String, dynamic>;
          return _users["users"];
        });

        users.add(email);
        userCollectionRef.set({"users": users});

      } on FirebaseAuthException catch(e) {
        String errMessage = messages[e.code]!;
        showDialog(context: context, builder: (context) => AlertMessageDialog(message: errMessage));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('계정생성'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
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
              const Spacer(),
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
        ),
      )
    );
  }
}