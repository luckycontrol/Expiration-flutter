import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

// FIXME: 출력용 클래스
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
    id: json["id"] as String,
    name: json["name"] as String,
    category: json["category"] as String,
    expiration: Platform.isIOS ? (json["expiration"] as Timestamp).toDate() : (json["expiration"] as DateTime),
    image: json["image"] as String
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "expiration": expiration,
      "image": image
    };
  }
}

// FIXME: 저장, 불러오기용 클래스
class ItemExchange {
  String id;
  String name;
  String category;
  DateTime expiration;

  ItemExchange({
    required this.id,
    required this.name,
    required this.category,
    required this.expiration
  });

  ItemExchange.fromJson(Map<String, dynamic> json)
  : this(
    id: json["id"] as String,
    name: json["name"] as String,
    category: json["category"] as String,
    expiration: Platform.isIOS ? (json["expiration"] as Timestamp).toDate() : (json["expiration"] as DateTime),
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "expiration": expiration
    };
  }
}