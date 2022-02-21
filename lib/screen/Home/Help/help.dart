import 'package:flutter/material.dart';

class HelpWidget extends StatefulWidget {
  HelpWidget({Key? key}) : super(key: key);

  @override
  State<HelpWidget> createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.of(context).pop()
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  children: [
                    const Text(
                      "유통기한을 확인하는 방법",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Image.asset("assets/oneWeek.png", width: 35, height: 35),
                        const SizedBox(width: 15),
                        const Text("유통기한이 일주일 이상 남은 식품")
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Image.asset("assets/threeDaysLeft.png", width: 35, height: 35),
                        const SizedBox(width: 15),
                        const Text("유통기한이 4일 이상 ~ 7일 미만인 식품")
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Image.asset("assets/oneDayLeft.png", width: 35, height: 35),
                        const SizedBox(width: 15),
                        const Text("유통기한이 3일 이하인 식품")
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Image.asset("assets/finish.png", width: 35, height: 35),
                        const SizedBox(width: 15),
                        const Text("유통기한이 지난 식품")
                      ],
                    )
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }
}