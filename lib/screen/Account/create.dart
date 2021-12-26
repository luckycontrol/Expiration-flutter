import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({ Key? key }) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
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
                      decoration: const InputDecoration(
                        labelText: '아이디'
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '비밀번호'
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  primary: Colors.green
                ),
                onPressed: () {}, 
                child: const Text('계정 생성')
              )
            ],
          ),
        ),
      )
    );
  }
}