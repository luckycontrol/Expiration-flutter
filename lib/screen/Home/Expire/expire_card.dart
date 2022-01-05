import 'package:flutter/material.dart';
import 'package:food_manager/model/item.dart';

class ExpireCard extends StatelessWidget {

  Item item;

  ExpireCard({ Key? key, required this.item }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(context: context, builder: (context) => checkProduct(context)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(item.image)
            ),
            const SizedBox(height: 10),
            Text(item.name)
          ],
        ),
      )
    );
  }

  // 유통기한이 얼마 안남은 품목 확인하는 위젯
  Widget checkProduct(BuildContext context) {

    int leftTime = item.expiration.day - DateTime.now().day;

    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "유통기한이 얼마 남지 않았어요!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                )
              )
            ),
            const SizedBox(height: 15),
            // 사진
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(item.image),
                  fit: BoxFit.cover
                )
              )
            ),
            const SizedBox(height: 20),
            // 이름
            Text(item.name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Row(
              children: [
                // 카테고리
                Text(item.category, style: const TextStyle(fontSize: 18)),
                const Spacer(),
                // 유통기한
                Text("${item.expiration.year}년 ${item.expiration.month}월 ${item.expiration.day}일", style: const TextStyle(fontSize: 18))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Spacer(),
                Text(
                  leftTime >= 0 ? leftTime != 0 ? leftTime == 1 ? "하루 남았어요!" : "$leftTime일 남았어요!" : "오늘 까지에요!" : "지났어요!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
            const SizedBox(height: 10),
            if (leftTime < 0)
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "${item.name} 삭제",
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                primary: Colors.green[800]
              )
            )
          ],
        )
      )
    );
  }
}