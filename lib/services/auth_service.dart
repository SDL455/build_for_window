import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app/constants/app_constants.dart';
import '../data/models/restaurant_model.dart';
import '../data/models/user_model.dart';

/// Admin authentication. Only users with `role == admin` may sign in here.
/// Admins also provision Customer / Merchant / Rider accounts.
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (cred.user == null) return const Left('Authentication failed.');
      final user = await getUserModel(cred.user!.uid);
      if (user == null) return const Left('Account not found.');
      if (user.role != AppConstants.roleAdmin) {
        await _auth.signOut();
        return const Left('This account is not authorized for the admin console.');
      }
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_mapAuthError(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Create a Customer / Merchant / Rider account (admin-only provisioning).
  /// Merchants also get a linked, pre-approved restaurant record.
  Future<Either<String, UserModel>> createUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String role, // customer | merchant | rider
    String? restaurantName, // required when role == merchant
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = cred.user!.uid;
      String? restaurantId;
      if (role == AppConstants.roleMerchant) {
        final doc = _firestore
            .collection(AppConstants.restaurantsCollection)
            .doc();
        restaurantId = doc.id;
        final restaurant = RestaurantModel(
          id: doc.id,
          name: restaurantName?.trim() ?? '$fullName Store',
          ownerId: uid,
          isApproved: true,
          isOpen: true,
          createdAt: DateTime.now(),
        );
        await doc.set(restaurant.toMap());
      }
      final user = UserModel(
        uid: uid,
        email: email.trim(),
        fullName: fullName.trim(),
        phone: phone.trim(),
        role: role,
        restaurantId: restaurantId,
        merchantApproved: role == AppConstants.roleMerchant,
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set(user.toMap());
      await cred.user?.updateDisplayName(fullName.trim());
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_mapAuthError(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Self-registration for the first/any admin account.
  Future<Either<String, UserModel>> registerAdmin({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = cred.user!.uid;
      final user = UserModel(
        uid: uid,
        email: email.trim(),
        fullName: fullName.trim(),
        phone: phone.trim(),
        role: AppConstants.roleAdmin,
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set(user.toMap());
      await cred.user?.updateDisplayName(fullName.trim());
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_mapAuthError(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<UserModel?> getUserModel(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, id: doc.id);
  }

  Future<Either<String, void>> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update(user.toMap());
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> logout() async {
    try {
      await _auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No admin account found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'The password is too weak (min 6 characters).';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Authentication error.';
    }
  }
}
