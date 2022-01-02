import 'package:flutter/material.dart';
import 'package:food_manager/model/item.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Edit extends StatefulWidget {
  Edit({Key? key, required this.item, required this.categories, required this.editItem }) : super(key: key);

  final Item item;
  List<String> categories;
  void Function(Item) editItem;

  @override
  _EditState createState() => _EditState(item, categories, editItem);
}

class _EditState extends State<Edit> {
  Item item;
  List<String> categories;
  void Function(Item) editItem;

  late String name;
  late String category;
  late DateTime selectedDate;
  late String _image;

  final imagePicker = ImagePicker();
  
  _EditState(this.item, this.categories, this.editItem) {
    name = item.name;
    category = item.category;
    selectedDate = item.expiration;
    _image = item.image;
  }
  
  // FIXME: 카메라에서 사진 가져오기
  Future getImageFromCam() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() { 
      if (image != null) {
        _image = image.path;
      }
    });
  }

  // FIXME: 앨범에서 사진 가져오기
  Future getImageFromGallery() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() { 
      if (image != null) {
        _image = image.path;
      }
    });
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
                  "${item.name} 수정",
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
                        image: DecorationImage(
                          image: FileImage(File(_image)),
                          fit: BoxFit.fitWidth
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [ BoxShadow(color: Colors.grey, spreadRadius: 0.3) ]
                      ),
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      // FIXME: 이름
                      TextFormField(
                        initialValue: name,
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
                      // FIXME: 카테고리
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((elem) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: elem == category ? Colors.green[800] : Colors.black.withOpacity(0.4)
                                ),
                                child: Text(elem),
                                onPressed: () {
                                  setState(() { category = elem; });
                                },
                              ),
                            );
                          }).toList()
                        ),
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
                // FIXME: 수정하기 버튼
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    child: const Text("수정하기", style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      primary: Colors.green[800]
                    ),
                    onPressed: () {
                      bool result = check_input_field();

                      if (result) {
                        item.name = name;
                        item.category = category;
                        item.expiration = selectedDate;
                        item.image = _image;

                        setState(() {
                          editItem(item);
                        });
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