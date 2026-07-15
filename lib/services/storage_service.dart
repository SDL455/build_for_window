import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Image upload helper for admin (restaurant / product photos, etc.).
class StorageService {
  final FirebaseStorage _storage;
  final ImagePicker _picker;

  StorageService({FirebaseStorage? storage, ImagePicker? picker})
      : _storage = storage ?? FirebaseStorage.instance,
        _picker = picker ?? ImagePicker();

  Future<Either<String, File?>> pickImage({bool fromCamera = false}) async {
    try {
      final picked = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 70,
      );
      if (picked == null) return const Right(null);
      return Right(File(picked.path));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> uploadImage({
    required File file,
    required String path,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final task = await ref.putFile(file,
          SettableMetadata(contentType: 'image/jpeg'));
      final url = await task.ref.getDownloadURL();
      return Right(url);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> uploadImageWeb({
    required Uint8List bytes,
    required String path,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final task = await ref.putData(bytes,
          SettableMetadata(contentType: 'image/jpeg'));
      final url = await task.ref.getDownloadURL();
      return Right(url);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
