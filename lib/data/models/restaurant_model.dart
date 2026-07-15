import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String? ownerId;
  final String? description;
  final String? imageUrl;
  final String? coverUrl;
  final String? categoryId;
  final String? categoryName;
  final double rating;
  final int ratingCount;
  final double deliveryFee;
  final double minOrder;
  final int deliveryTimeMin;
  final bool isOpen;
  final bool isApproved;
  final double lat;
  final double lng;
  final String? address;
  final DateTime createdAt;

  const RestaurantModel({
    required this.id,
    required this.name,
    this.ownerId,
    this.description,
    this.imageUrl,
    this.coverUrl,
    this.categoryId,
    this.categoryName,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.deliveryFee = 2.0,
    this.minOrder = 0.0,
    this.deliveryTimeMin = 30,
    this.isOpen = true,
    this.isApproved = false,
    this.lat = 0.0,
    this.lng = 0.0,
    this.address,
    required this.createdAt,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> map, String id) {
    return RestaurantModel(
      id: id,
      name: map['name'] ?? '',
      ownerId: map['ownerId'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      coverUrl: map['coverUrl'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 2.0,
      minOrder: (map['minOrder'] as num?)?.toDouble() ?? 0.0,
      deliveryTimeMin: (map['deliveryTimeMin'] as num?)?.toInt() ?? 30,
      isOpen: map['isOpen'] ?? true,
      isApproved: map['isApproved'] ?? false,
      lat: (map['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (map['lng'] as num?)?.toDouble() ?? 0.0,
      address: map['address'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'ownerId': ownerId,
        'description': description,
        'imageUrl': imageUrl,
        'coverUrl': coverUrl,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'rating': rating,
        'ratingCount': ratingCount,
        'deliveryFee': deliveryFee,
        'minOrder': minOrder,
        'deliveryTimeMin': deliveryTimeMin,
        'isOpen': isOpen,
        'isApproved': isApproved,
        'lat': lat,
        'lng': lng,
        'address': address,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  RestaurantModel copyWith({
    String? name,
    String? description,
    String? imageUrl,
    String? coverUrl,
    bool? isOpen,
    bool? isApproved,
    double? deliveryFee,
    double? rating,
    int? ratingCount,
  }) =>
      RestaurantModel(
        id: id,
        name: name ?? this.name,
        ownerId: ownerId,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        coverUrl: coverUrl ?? this.coverUrl,
        categoryId: categoryId,
        categoryName: categoryName,
        rating: rating ?? this.rating,
        ratingCount: ratingCount ?? this.ratingCount,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        minOrder: minOrder,
        deliveryTimeMin: deliveryTimeMin,
        isOpen: isOpen ?? this.isOpen,
        isApproved: isApproved ?? this.isApproved,
        lat: lat,
        lng: lng,
        address: address,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [id, name, ownerId, isOpen, isApproved, rating];
}
