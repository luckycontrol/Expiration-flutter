import 'package:flutter/material.dart';
import 'package:food_manager/screen/Account/create.dart';
import 'package:food_manager/screen/Home/home.dart';
import 'package:food_manager/screen/Utils/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String email = "";
  String password = "";

  Map<String, String> messages = {
    "invalid-email": "이메일 형식이 옳지 않습니다.",
    "wrong-password": "비밀번호가 틀렸습니다.",
    "user-not-found": "사용자를 찾을 수 없습니다."
  };

  void handleLogin(String email, String password) async {
    if (email == "") {
      showDialog(context: context, builder: (context) => AlertMessageDialog(message: "이메일을 입력해주세요."));
      return;
    }

    if (password == "") {
      showDialog(context: context, builder: (context) => AlertMessageDialog(message: "비밀번호를 입력해주세요."));
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      String errMessage = messages[e.code]!;
      showDialog(context: context, builder: (context) => AlertMessageDialog(message: errMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      // FIXME: 아이디 폼
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text("아이디", style: TextStyle(color: Colors.green[800])),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          )
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                        onChanged: (value) { email = value; }
                      ),
                      // FIXME: 비밀번호 폼
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text("비밀번호", style: TextStyle(color: Colors.green[800])),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          )
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                        onChanged: (value) { password = value; }
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    primary: Colors.green
                  ),
                  onPressed: () { handleLogin(email, password); }, 
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  )
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '혹시 계정이 없으신가요?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAccount()));
                      },
                      child: const Text(
                        '계정생성',
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}