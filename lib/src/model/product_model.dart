// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon/src/model/user_model.dart';

class ProductModel {
  String id;
  String sellerId;
  String name;
  String description;
  String price;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel seller;
  ProductModel({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.seller,
  });

  ProductModel copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? description,
    String? price,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? seller,
  }) {
    return ProductModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seller: seller ?? this.seller,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sellerId': sellerId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'seller': seller.toMap(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      sellerId: map['sellerId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as String,
      image: map['image'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      seller: UserModel.fromMap(map['seller'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, sellerId: $sellerId, name: $name, description: $description, price: $price, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, seller: $seller)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sellerId == sellerId &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.image == image &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.seller == seller;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sellerId.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        image.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        seller.hashCode;
  }
}
