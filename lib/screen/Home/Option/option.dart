import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Option/alarm.dart';
import 'package:food_manager/screen/Home/Option/remove_account.dart';

class Option extends StatelessWidget {
  Option({Key? key}) : super(key: key);

  List<Map<String, dynamic>> options = [
    {
      "title": "알람시간 설정",
      "page": Alarm()
    },
    {
      "title": "회원탈퇴",
      "page": RemoveAccount()
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("설정"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: options.map((option) => OptionCard(option: option)).toList(),
        ),
      )
    );
  }
}

class OptionCard extends StatelessWidget {
  OptionCard({ Key? key, required this.option }) : super(key: key);

  Map<String, dynamic> option;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => option["page"])),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.2,
              color: Colors.black.withOpacity(0.5)
            )
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            children: [
              Text(option["title"], style: const TextStyle(fontSize: 16)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_outlined, size: 18)
            ],
          ),
        ),
      )
    );
  }
}