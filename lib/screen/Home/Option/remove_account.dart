import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RemoveAccount extends StatelessWidget {
  const RemoveAccount({Key? key}) : super(key: key);

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
                  await FirebaseAuth.instance.currentUser!.delete();
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