import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alarm extends StatefulWidget {
  Alarm({Key? key}) : super(key: key);

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {

  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("알람시간 설정"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "매일 몇 시에 알람을 받으실건가요?",
              style: TextStyle(
                fontSize: 18
              )
            ),
            const Text(
              "알람은 유통기한이 임박한 품목이 \n있을 때만 보내드려요.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey
              )
            ),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => showModalBottomSheet(context: context, builder: (context) => DatePicker(context)),
                  child: Text(
                    "${time.hour}시 ${time.minute}분",
                    style: const TextStyle(fontSize: 16)
                  )
                )
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                primary: Colors.green[800]
              ),
              child: const Text("알람 설정", style: TextStyle(fontWeight: FontWeight.bold)) 
            ),
            const SizedBox(height: 25)
          ],
        ),
      )
    );
  }

  Widget DatePicker(BuildContext context) {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      initialDateTime: DateTime(1969, 1, 1, ),
      onDateTimeChanged: (DateTime newDate) {
        setState(() { time = newDate; });
      }
    );
  }
}