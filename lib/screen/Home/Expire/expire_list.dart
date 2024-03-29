import 'package:flutter/material.dart';
import 'package:food_manager/screen/Home/Expire/expire_card.dart';
import 'package:food_manager/model/item.dart';

class ExpireList extends StatelessWidget {
  ExpireList({ Key? key, required this.expire_soon_list }) : super(key: key);

  List<Item> expire_soon_list;

  @override
  Widget build(BuildContext context) {
    return expire_soon_list.isEmpty
    ? const SizedBox.shrink()
    : Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
              child: Text(
                "유통기한이 곧 끝나가요!",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: expire_soon_list.map((item) => ExpireCard(item: item)).toList(),
              ),
            )
          ],
        )
      ),
    );
  }
}