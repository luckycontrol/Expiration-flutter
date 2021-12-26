import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: '아이디'
                        ),
                        autocorrect: false,
                        enableSuggestions: false
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: '비밀번호'
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    primary: Colors.green
                  ),
                  onPressed: () {}, 
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
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
                        Navigator.pushNamed(context, '/account/create');
                      },
                      child: Text(
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