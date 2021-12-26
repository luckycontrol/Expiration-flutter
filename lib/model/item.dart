import 'package:image_picker/image_picker.dart';

class Item {
  String name;
  String category;
  DateTime expiration;
  PickedFile image;

  Item({
    required this.name,
    required this.category,
    required this.expiration,
    required this.image
  });  
}