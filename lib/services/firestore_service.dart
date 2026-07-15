import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../app/constants/app_constants.dart';
import '../data/models/order_model.dart';
import '../data/models/restaurant_model.dart';
import '../data/models/user_model.dart';

/// Firestore access for the admin console: full visibility & management of
/// users, restaurants, products and orders across the platform.
class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  // -------------------- Users --------------------
  Stream<List<UserModel>> usersStream() {
    return _db
        .collection(AppConstants.usersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => UserModel.fromMap(d.data(), id: d.id)).toList());
  }

  Future<Either<String, void>> deleteUser(String uid) async {
    try {
      await _db.collection(AppConstants.usersCollection).doc(uid).delete();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // -------------------- Restaurants --------------------
  Stream<List<RestaurantModel>> restaurantsStream() {
    return _db
        .collection(AppConstants.restaurantsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => RestaurantModel.fromMap(d.data(), d.id))
            .toList());
  }

  Future<Either<String, void>> addRestaurant(RestaurantModel r) async {
    try {
      await _db.collection(AppConstants.restaurantsCollection).add(r.toMap());
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> updateRestaurant(RestaurantModel r) async {
    try {
      await _db
          .collection(AppConstants.restaurantsCollection)
          .doc(r.id)
          .update(r.toMap());
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> deleteRestaurant(String id) async {
    try {
      await _db.collection(AppConstants.restaurantsCollection).doc(id).delete();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // -------------------- Orders --------------------
  Stream<List<OrderModel>> ordersStream() {
    return _db
        .collection(AppConstants.ordersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_ordersFrom);
  }

  Future<Either<String, void>> updateOrder(OrderModel order) async {
    try {
      await _db
          .collection(AppConstants.ordersCollection)
          .doc(order.id)
          .update(order.toMap());
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  List<OrderModel> _ordersFrom(QuerySnapshot snap) => snap.docs
      .map((d) => OrderModel.fromMap(d.data() as Map<String, dynamic>, d.id))
      .toList();
}
