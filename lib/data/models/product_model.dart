import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final double? discountedPrice;
  final String? categoryId;
  final String? categoryName;
  final bool isAvailable;
  final bool isPopular;
  final int stock;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    this.discountedPrice,
    this.categoryId,
    this.categoryName,
    this.isAvailable = true,
    this.isPopular = false,
    this.stock = 999,
    required this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      restaurantId: map['restaurantId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (map['discountedPrice'] as num?)?.toDouble(),
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      isAvailable: map['isAvailable'] ?? true,
      isPopular: map['isPopular'] ?? false,
      stock: (map['stock'] as num?)?.toInt() ?? 999,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'restaurantId': restaurantId,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'discountedPrice': discountedPrice,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'isAvailable': isAvailable,
        'isPopular': isPopular,
        'stock': stock,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  double get effectivePrice => discountedPrice ?? price;
  bool get hasDiscount => discountedPrice != null && discountedPrice! < price;

  @override
  List<Object?> get props => [id, restaurantId, name, price, isAvailable];
}
