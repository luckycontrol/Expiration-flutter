import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_manager/get/UserController.dart';
import 'package:food_manager/api/push_manager.dart';
import 'package:get/get.dart';

class Alarm extends StatefulWidget {
  Alarm({Key? key}) : super(key: key);

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {

  final UserController uc = Get.find();

  DateTime time = DateTime.now();

  void setDailyAlarm(String email, DateTime _time) {
    DocumentReference ref = FirebaseFirestore.instance.collection(email).doc("alarm");
    ref.set({"alarm": _time });
  }

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
              "알람은 유통기한이 임박한 품목(유통기한이 끝나기 3일전)이 \n있을 때만 보내드려요.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey
              )
            ),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () => showModalBottomSheet(context: context, builder: (context) => DatePicker(context)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[800]
                  ),
                  child: Text(
                    "${time.hour}시 ${time.minute}분",
                    style: const TextStyle(fontSize: 16)
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () { 
                setDailyAlarm(uc.email.value, time);
                pushManager.setAlarm(uc.email.value, time);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                primary: Colors.green[800],
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
      initialDateTime: DateTime(1969, 3, 3, ),
      onDateTimeChanged: (DateTime newDate) {
        setState(() { time = newDate; });
      }
    );
  }
}