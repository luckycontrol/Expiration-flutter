import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var email = "".obs;
  var nickname = "".obs;
  
  // 이메일 초기화
  setEmail(_email) {
    email.value = _email;
  }

  // 닉네임 초기화
  setNickname() async {
    DocumentReference ref = FirebaseFirestore.instance.collection(email.value).doc("user");

    String _nickname = await ref
    .get()
    .then((snapshot) {
      Map<String, dynamic> _nickname = snapshot.data() as Map<String, dynamic>;
      return _nickname["nickname"];
    });

    nickname.value = _nickname;
  }
}