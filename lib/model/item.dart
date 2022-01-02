import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class Item {
  String id;
  String name;
  String category;
  DateTime expiration;
  String image;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.expiration,
    required this.image
  });

  Item.fromJson(Map<String, dynamic> json)
  : this(
    id: json["id"]! as String,
    name: json["name"]! as String,
    category: json["category"]! as String,
    expiration: Platform.isIOS ? (json["expiration"]! as Timestamp).toDate() : (json["expiration"]! as DateTime),
    image: json["image"]! as String
  );

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "expiration": expiration,
      "image": image
    };
  }
}

class Item_Save {
  String id;
  String name;
  String category;
  DateTime expiration;

  Item_Save({
    required this.id,
    required this.name,
    required this.category,
    required this.expiration
  });

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "expiration": expiration
    };
  }
}