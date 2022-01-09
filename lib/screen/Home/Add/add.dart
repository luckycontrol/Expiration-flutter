import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_manager/model/item.dart';
import 'package:food_manager/get/UserController.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:food_manager/get/ProductController.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'dart:io';

class Add extends StatefulWidget {
  Add({ 
    Key? key,
  }) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  
  _AddState();

  final UserController uc = Get.find();
  final CategoryController cc = Get.find();
  final ProductController pc = Get.find();

  String name = "";
  final imagePicker = ImagePicker();
  PickedFile? _image;
  DateTime selectedDate = DateTime.now();

  var uuid = Uuid();

  // FIXME: 카메라로 추가
  Future getImageFromCam() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() { _image = image; });
  }

  // FIXME: 앨범에서 추가
  Future getImageFromGallery() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() { _image = image; });
  }

  // FIXME: 빈 값 체크
  bool check_input_field() {
    if (_image == null) {
      showDialog(context: context, builder: (context) => buildNullCheckModal(context, "이미지를 넣어주세요!"));
      return false;
    }

    if (name == "") {
      showDialog(context: context, builder: (context) => buildNullCheckModal(context, "품목의 이름을 기입해주세요!"));
      return false;
    }

    return true;
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
                  "${cc.selectedCategory} 추가",
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
                        boxShadow: const [ BoxShadow(color: Colors.grey, spreadRadius: 0.3) ]
                      ),
                      child: _image == null
                      ? const Center(
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      // FIXME: 이름
                      TextFormField(
                        autocorrect: false,
                        cursorColor: Colors.green[800],
                        decoration: InputDecoration(
                          label: Text("이름", style: TextStyle(color: Colors.green[800])),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          )
                        ),
                        onChanged: (value) {
                          setState(() { name = value; });
                        }
                      ),
                      // FIXME: 유통기한
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
                            const Spacer(),
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
                    child: const Text("추가하기", style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      primary: Colors.green[800]
                    ),
                    onPressed: () {
                      bool result = check_input_field();

                      if (result) {
                        Item newItem = Item(
                          id: uuid.v4(),
                          name: name,
                          category: cc.selectedCategory.value,
                          expiration: selectedDate,
                          image: _image!.path
                        );

                        pc.addItem(uc.email as String, newItem);
                        Navigator.of(context).pop();
                      }
                    }
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
              onTap: () { 
                getImageFromCam();
                Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                child: Row(
                  children: const [
                    Icon(Icons.photo_camera, size: 25.0),
                    SizedBox(width: 10.0),
                    Text("카메라로 촬영")
                  ],
                )
              )
            ),
            GestureDetector(
              onTap: () { 
                getImageFromGallery();
                Navigator.of(context).pop(); 
              },
              child: Container(
                height: 50,
                child: Row(
                  children: const [
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

  // FIXME: 빈 공간 알림 Alert
  Widget buildNullCheckModal(BuildContext context, String message) {
    return AlertDialog(
      title: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red[300],
    );
  }
}