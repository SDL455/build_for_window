import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final String role; // admin | customer | merchant | rider
  final String? photoUrl;
  final String? fcmToken;
  final DateTime createdAt;
  final String? defaultAddress;
  final double? defaultLat;
  final double? defaultLng;
  final String? restaurantId;
  final bool merchantApproved;
  final bool isAvailable;
  final String? vehicleType;
  final double? riderLat;
  final double? riderLng;
  final double riderRating;

  const UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    this.photoUrl,
    this.fcmToken,
    required this.createdAt,
    this.defaultAddress,
    this.defaultLat,
    this.defaultLng,
    this.restaurantId,
    this.merchantApproved = false,
    this.isAvailable = false,
    this.vehicleType,
    this.riderLat,
    this.riderLng,
    this.riderRating = 0.0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return UserModel(
      uid: id ?? map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'customer',
      photoUrl: map['photoUrl'],
      fcmToken: map['fcmToken'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now(),
      defaultAddress: map['defaultAddress'],
      defaultLat: (map['defaultLat'] as num?)?.toDouble(),
      defaultLng: (map['defaultLng'] as num?)?.toDouble(),
      restaurantId: map['restaurantId'],
      merchantApproved: map['merchantApproved'] ?? false,
      isAvailable: map['isAvailable'] ?? false,
      vehicleType: map['vehicleType'],
      riderLat: (map['riderLat'] as num?)?.toDouble(),
      riderLng: (map['riderLng'] as num?)?.toDouble(),
      riderRating: (map['riderRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'phone': phone,
        'role': role,
        'photoUrl': photoUrl,
        'fcmToken': fcmToken,
        'createdAt': Timestamp.fromDate(createdAt),
        'defaultAddress': defaultAddress,
        'defaultLat': defaultLat,
        'defaultLng': defaultLng,
        'restaurantId': restaurantId,
        'merchantApproved': merchantApproved,
        'isAvailable': isAvailable,
        'vehicleType': vehicleType,
        'riderLat': riderLat,
        'riderLng': riderLng,
        'riderRating': riderRating,
      };

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? photoUrl,
    String? restaurantId,
    bool? merchantApproved,
    bool? isAvailable,
    String? vehicleType,
    String? fcmToken,
  }) =>
      UserModel(
        uid: uid,
        email: email,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        role: role,
        photoUrl: photoUrl ?? this.photoUrl,
        fcmToken: fcmToken ?? this.fcmToken,
        createdAt: createdAt,
        defaultAddress: defaultAddress,
        defaultLat: defaultLat,
        defaultLng: defaultLng,
        restaurantId: restaurantId ?? this.restaurantId,
        merchantApproved: merchantApproved ?? this.merchantApproved,
        isAvailable: isAvailable ?? this.isAvailable,
        vehicleType: vehicleType ?? this.vehicleType,
        riderLat: riderLat,
        riderLng: riderLng,
        riderRating: riderRating,
      );

  bool get isCustomer => role == 'customer';
  bool get isMerchant => role == 'merchant';
  bool get isRider => role == 'rider';
  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [uid, email, fullName, phone, role, restaurantId];
}
