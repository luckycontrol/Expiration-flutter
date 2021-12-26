import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Add extends StatefulWidget {
  Add({Key? key, required this.selectedCategory }) : super(key: key);

  String selectedCategory;

  @override
  _AddState createState() => _AddState(selectedCategory: selectedCategory);
}

class _AddState extends State<Add> {
  
  _AddState({ required this.selectedCategory });

  final String selectedCategory;
  final imagePicker = ImagePicker();
  PickedFile? _image;
  DateTime selectedDate = DateTime.now();

  Future getImageFromCam() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() { _image = image; });
  }

  Future getImageFromGallery() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() { _image = image; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.of(context).pop()
                  ),
                ),
                Text(
                  "$selectedCategory 추가",
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600
                  )
                ),
                // FIXME: 이미지 선택 창
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context, 
                        builder: buildBottomSheet
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 300.0,
                      decoration: BoxDecoration(
                        image: _image != null ? DecorationImage(
                          image: FileImage(File(_image!.path)),
                          fit: BoxFit.fitWidth
                        ) : null,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [ BoxShadow(color: Colors.grey, spreadRadius: 0.3) ]
                      ),
                      child: _image == null
                      ? Center(
                        child: Text(
                          "클릭하여 이미지를 추가해주세요.",
                          style: TextStyle(
                            fontSize: 18.0
                          )
                        )
                      )
                      : null
                    ),
                  )
                ),
                // FIXME: 이름, 유통기한
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: false,
                        cursorColor: Colors.green[800],
                        decoration: InputDecoration(
                          label: Text("이름", style: TextStyle(color: Colors.green[800])),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          )
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Text(
                              "유통기한",
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 15.0
                              )
                            ),
                            Spacer(),
                            TextButton(
                              child: Text("${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일 까지"),
                              onPressed: () { 
                                Future<DateTime?> expiration = showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2100));
                                expiration.then((dateTime) {
                                  setState(() {
                                    if (dateTime != null) {
                                      selectedDate = dateTime;
                                    }
                                  });
                                });
                              }
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // FIXME: 추가하기 버튼
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    child: Text("추가하기", style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      primary: Colors.green[800]
                    ),
                    onPressed: () {}
                  ),
                ),
              ],
            )
          )
        )
    );
  }

  // 카메라로 촬영 or 앨범에서 선택
  Widget buildBottomSheet(BuildContext context) {
    return Container(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => getImageFromCam(),
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Icon(Icons.photo_camera, size: 25.0),
                    SizedBox(width: 10.0),
                    Text("카메라로 촬영")
                  ],
                )
              )
            ),
            GestureDetector(
              onTap: () => getImageFromGallery(),
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Icon(Icons.photo, size: 25.0),
                    SizedBox(width: 10.0),
                    Text("앨범에서 가져오기")
                  ],
                )
              )
            ),
          ],
        ),
      )
    );
  }

  // 데이트 피커
  Widget buildDatePicker(BuildContext context) {
    return Container(

    );
  }
}