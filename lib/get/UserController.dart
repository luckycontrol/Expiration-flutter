import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var email = "".obs;
  var nickname = "".obs;
  
  // 이메일 초기화
  setEmail(String _email) {
    email.value = _email;
  }

  // 닉네임 초기화
  setNickname(String _email) async {
    DocumentReference ref = FirebaseFirestore.instance.collection(_email).doc("user");

    String _nickname = await ref.get().then((snapshot) {
      Map<String, dynamic> _nickname = snapshot.data() as Map<String, dynamic>;
      return _nickname["nickname"] as String;
    });

    nickname.value = _nickname;
  }

  // 로그인
  setLogin(FirebaseAuth auth) async {
    String _email = auth.currentUser!.email!;
    DocumentReference ref = FirebaseFirestore.instance.collection(_email).doc("user");

    String password = await ref.get().then((snapshot) {
      Map<String, dynamic> _password = snapshot.data() as Map<String, dynamic>;
      return _password["password"] as String;
    });

    await auth.signInWithEmailAndPassword(email: _email, password: password);
  }

  // 회원탈퇴
  setDelete(FirebaseAuth auth) async {
    auth.currentUser!.delete();
  }
}