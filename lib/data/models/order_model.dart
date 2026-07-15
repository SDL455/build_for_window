import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderItem {
  final String productId;
  final String name;
  final String? imageUrl;
  final double price;
  final int quantity;
  final String? note;

  OrderItem({
    required this.productId,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.quantity,
    this.note,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
        productId: map['productId'] ?? '',
        name: map['name'] ?? '',
        imageUrl: map['imageUrl'],
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        quantity: (map['quantity'] as num?)?.toInt() ?? 1,
        note: map['note'],
      );

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
        'note': note,
      };

  double get total => price * quantity;
}

class OrderModel extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final String? customerPhone;
  final String restaurantId;
  final String restaurantName;
  final String? merchantId;
  final String? riderId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String status;
  final String paymentMethod;
  final bool isPaid;
  final String? deliveryAddress;
  final double? deliveryLat;
  final double? deliveryLng;
  final String? note;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final int? estimatedMinutes;

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    required this.restaurantId,
    required this.restaurantName,
    this.merchantId,
    this.riderId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.paymentMethod,
    this.isPaid = false,
    this.deliveryAddress,
    this.deliveryLat,
    this.deliveryLng,
    this.note,
    required this.createdAt,
    this.acceptedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.estimatedMinutes,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) => OrderModel(
        id: id,
        customerId: map['customerId'] ?? '',
        customerName: map['customerName'] ?? '',
        customerPhone: map['customerPhone'],
        restaurantId: map['restaurantId'] ?? '',
        restaurantName: map['restaurantName'] ?? '',
        merchantId: map['merchantId'],
        riderId: map['riderId'],
        items: (map['items'] as List? ?? [])
            .map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
            .toList(),
        subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
        deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
        total: (map['total'] as num?)?.toDouble() ?? 0.0,
        status: map['status'] ?? 'pending',
        paymentMethod: map['paymentMethod'] ?? 'cash',
        isPaid: map['isPaid'] ?? false,
        deliveryAddress: map['deliveryAddress'],
        deliveryLat: (map['deliveryLat'] as num?)?.toDouble(),
        deliveryLng: (map['deliveryLng'] as num?)?.toDouble(),
        note: map['note'],
        createdAt: map['createdAt'] is Timestamp
            ? (map['createdAt'] as Timestamp).toDate()
            : DateTime.now(),
        acceptedAt: map['acceptedAt'] is Timestamp
            ? (map['acceptedAt'] as Timestamp).toDate()
            : null,
        pickedUpAt: map['pickedUpAt'] is Timestamp
            ? (map['pickedUpAt'] as Timestamp).toDate()
            : null,
        deliveredAt: map['deliveredAt'] is Timestamp
            ? (map['deliveredAt'] as Timestamp).toDate()
            : null,
        estimatedMinutes: (map['estimatedMinutes'] as num?)?.toInt(),
      );

  Map<String, dynamic> toMap() => {
        'customerId': customerId,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'restaurantId': restaurantId,
        'restaurantName': restaurantName,
        'merchantId': merchantId,
        'riderId': riderId,
        'items': items.map((e) => e.toMap()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'total': total,
        'status': status,
        'paymentMethod': paymentMethod,
        'isPaid': isPaid,
        'deliveryAddress': deliveryAddress,
        'deliveryLat': deliveryLat,
        'deliveryLng': deliveryLng,
        'note': note,
        'createdAt': Timestamp.fromDate(createdAt),
        'acceptedAt': acceptedAt == null ? null : Timestamp.fromDate(acceptedAt!),
        'pickedUpAt': pickedUpAt == null ? null : Timestamp.fromDate(pickedUpAt!),
        'deliveredAt': deliveredAt == null ? null : Timestamp.fromDate(deliveredAt!),
        'estimatedMinutes': estimatedMinutes,
      };

  OrderModel copyWith({
    String? status,
    String? riderId,
    bool? isPaid,
    DateTime? acceptedAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
  }) =>
      OrderModel(
        id: id,
        customerId: customerId,
        customerName: customerName,
        customerPhone: customerPhone,
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        merchantId: merchantId,
        riderId: riderId ?? this.riderId,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        status: status ?? this.status,
        paymentMethod: paymentMethod,
        isPaid: isPaid ?? this.isPaid,
        deliveryAddress: deliveryAddress,
        deliveryLat: deliveryLat,
        deliveryLng: deliveryLng,
        note: note,
        createdAt: createdAt,
        acceptedAt: acceptedAt ?? this.acceptedAt,
        pickedUpAt: pickedUpAt ?? this.pickedUpAt,
        deliveredAt: deliveredAt ?? this.deliveredAt,
        estimatedMinutes: estimatedMinutes,
      );

  @override
  List<Object?> get props => [id, status, riderId, total];
}
