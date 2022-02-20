import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_manager/get/CategoryController.dart';
import 'package:food_manager/model/item.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class AddDialog extends StatefulWidget {
  AddDialog({Key? key, required this.itemList, required this.addItem }) : super(key: key);

  List<Item> itemList;
  Function(Item) addItem;

  @override
  _AddDialogState createState() => _AddDialogState(itemList: itemList, addItem: addItem);
}

class _AddDialogState extends State<AddDialog> {

  List<Item> itemList;
  Function(Item) addItem;

  final CategoryController cc = Get.find();

  var uuid = const Uuid();

  String name = "";
  final imagePicker = ImagePicker();
  PickedFile? _image;
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  _AddDialogState({ required this.itemList, required this.addItem });

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
  bool checkInputField() {
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
    Size size = MediaQuery.of(context).size;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "추가하실 ${cc.selectedCategory}을/를 알려주세요!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 15),
              // 이미지 추가 컨테이너
              GestureDetector(
                onTap: () => showModalBottomSheet(context: context, builder: buildBottomSheet),
                child: Container(
                  height: size.height * 1/4,
                  decoration: BoxDecoration(
                    image: _image != null ? DecorationImage(
                      image: FileImage(File(_image!.path)),
                      fit: BoxFit.cover,
                    ) : null,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [ BoxShadow(color: Colors.grey, spreadRadius: 0.5, blurRadius: 1.5) ]
                  ),
                  child: _image == null
                  ? const Center(
                    child: Text(
                      "클릭하여 이미지를 추가해주세요!",
                      style: TextStyle(fontSize: 16)
                    )
                  )
                  : null,
                )
              ),
              // 품목 이름
              TextFormField(
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  label: Text("${cc.selectedCategory} 이름", style: TextStyle(color: Colors.green[800])),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)
                  )
                ),
                onChanged: (value) => setState(() { name = value; })
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  // 유통기한
                  Text(
                    "유통기한",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[800]
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
                  ),
                ],
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width, 40),
                  primary: Colors.green[800]
                ),
                onPressed:() {
                  bool result = checkInputField();

                  if (result) {
                    Item newItem = Item(
                      id: uuid.v4(),
                      name: name,
                      category: cc.selectedCategory.value,
                      expiration: selectedDate,
                      image: _image!.path
                    );

                    print(newItem.id);

                    addItem(newItem);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  "추가",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                )
              )
            ],
          )
          )
        ),
      )
    );
  }

  // FIXME: 빈 공간 알림 Alert
  Widget buildNullCheckModal(BuildContext context, String message) {
    return AlertDialog(
      title: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.red[300],
    );
  }

  // 카메라로 촬영 or 앨범에서 선택
  Widget buildBottomSheet(BuildContext context) {
    return SizedBox(
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
              child: SizedBox(
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
              child: SizedBox(
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
}