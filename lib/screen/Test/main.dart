import 'package:flutter/material.dart';
import 'package:food_manager/screen/Test/test.dart';
import 'package:food_manager/screen/Test/test2.dart';

class TestWidget extends StatefulWidget {
  TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {

  List<String> categories = ["정육", "생선", "채소"];

  void change(idx) {
    setState(() { 
      categories[idx] = "수정";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("테스트")
      ),
      body: Column(
        children: [
          TestList(categories),
          ElevatedButton(
            child: Text("CLICK"),
            onPressed: () => showModalBottomSheet(context: context, builder: (context) => Test(categories, (idx) { setState(() { categories[idx] = "수정됨"; }); }))
          )
        ],
      )
    );
  }
}