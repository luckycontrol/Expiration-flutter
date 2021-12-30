import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Test extends StatefulWidget {
  Test(this.categories, this.change);

  List<String> categories;
  void Function(int) change;

  @override
  _TestState createState() => _TestState(categories, change);
}

class _TestState extends State<Test> {

  List<String> categories;
  void Function(int) change;

  _TestState(this.categories, this.change);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((category) {
        return Slidable(
          endActionPane: ActionPane(
            motion: DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  int idx = categories.indexOf(category);
                  setState(() { categories[idx] = category; });
                  change(idx);
                },
                label: "수정",
                backgroundColor: Colors.indigo,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              height: 60,
              child: Text(category),
            ),
          ),
        );
      }).toList(),
    );
  }
}