import 'package:cloud_firestore/cloud_firestore.dart';
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
}