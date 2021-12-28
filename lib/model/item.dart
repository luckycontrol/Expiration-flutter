import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Item {
  String id;
  String name;
  String category;
  DateTime expiration;
  PickedFile image;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.expiration,
    required this.image
  });  
}