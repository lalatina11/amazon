// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CartModel {
  String id;
  String userId;
  String productId;
  int quantity;
  double totalPrice;
  DateTime createdAt;
  DateTime updatedAt;
  ProductCartModel? product; // ← add this
  CartModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  CartModel copyWith({
    String? id,
    String? userId,
    String? productId,
    int? quantity,
    double? totalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProductCartModel? product,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'product': product?.toMap(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
      totalPrice: map['totalPrice'] as double,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      product: map['product'] != null
          ? ProductCartModel.fromMap(map['product'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartModel(id: $id, userId: $userId, productId: $productId, quantity: $quantity, totalPrice: $totalPrice, createdAt: $createdAt, updatedAt: $updatedAt, product: $product)';
  }

  @override
  bool operator ==(covariant CartModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.productId == productId &&
        other.quantity == quantity &&
        other.totalPrice == totalPrice &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.product == product;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        productId.hashCode ^
        quantity.hashCode ^
        totalPrice.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        product.hashCode;
  }
}

class ProductCartModel {
  String id;
  String sellerId;
  String name;
  String description;
  String price;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  ProductCartModel({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  ProductCartModel copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? description,
    String? price,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductCartModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    };
  }

  factory ProductCartModel.fromMap(Map<String, dynamic> map) {
    return ProductCartModel(
      id: map['id'] as String,
      sellerId: map['sellerId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as String,
      image: map['image'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCartModel.fromJson(String source) =>
      ProductCartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductCartModel(id: $id, sellerId: $sellerId, name: $name, description: $description, price: $price, image: $image, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ProductCartModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sellerId == sellerId &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.image == image &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
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
        updatedAt.hashCode;
  }
}
