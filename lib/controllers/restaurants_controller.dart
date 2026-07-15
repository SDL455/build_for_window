import 'package:get/get.dart';

import '../app/utils/helpers.dart';
import '../data/models/restaurant_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

/// Manage restaurants: create, edit, approve, delete.
class RestaurantsController extends GetxController {
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  RestaurantsController(this._firestoreService, this._storageService);

  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final RxString search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _firestoreService.restaurantsStream().listen((list) {
      restaurants.value = list;
      _applyFilter();
    });
  }

  final RxList<RestaurantModel> filtered = <RestaurantModel>[].obs;

  void _applyFilter() {
    final q = search.value.toLowerCase();
    if (q.isEmpty) {
      filtered.value = restaurants;
    } else {
      filtered.value =
          restaurants.where((r) => r.name.toLowerCase().contains(q)).toList();
    }
  }

  void onSearch(String v) {
    search.value = v;
    _applyFilter();
  }

  Future<bool> save({
    required String name,
    required String description,
    required String categoryName,
    required double deliveryFee,
    required int deliveryTimeMin,
    required bool isApproved,
    RestaurantModel? existing,
    String? imageUrl,
  }) async {
    if (existing != null) {
      final updated = existing.copyWith(
        name: name,
        description: description,
        // categoryName: categoryName,
        deliveryFee: deliveryFee,
        isApproved: isApproved,
        imageUrl: imageUrl ?? existing.imageUrl,
      );
      final res = await _firestoreService.updateRestaurant(updated);
      return res.fold((e) {
        Helpers.showError(e);
        return false;
      }, (_) {
        Helpers.showSuccess('Restaurant updated');
        return true;
      });
    }
    final r = RestaurantModel(
      id: '',
      name: name,
      description: description,
      categoryName: categoryName,
      deliveryFee: deliveryFee,
      deliveryTimeMin: deliveryTimeMin,
      isApproved: isApproved,
      isOpen: true,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    final res = await _firestoreService.addRestaurant(r);
    return res.fold((e) {
      Helpers.showError(e);
      return false;
    }, (_) {
      Helpers.showSuccess('Restaurant added');
      return true;
    });
  }

  Future<void> toggleApproval(RestaurantModel r) async {
    final updated = r.copyWith(isApproved: !r.isApproved);
    final res = await _firestoreService.updateRestaurant(updated);
    res.fold((e) => Helpers.showError(e), (_) {});
  }

  Future<void> toggleOpen(RestaurantModel r) async {
    final updated = r.copyWith(isOpen: !r.isOpen);
    final res = await _firestoreService.updateRestaurant(updated);
    res.fold((e) => Helpers.showError(e), (_) {});
  }

  Future<void> delete(RestaurantModel r) async {
    final ok = await Helpers.confirm(
        title: 'Delete restaurant', message: 'Remove ${r.name}?');
    if (!ok) return;
    final res = await _firestoreService.deleteRestaurant(r.id);
    res.fold(
        (e) => Helpers.showError(e), (_) => Helpers.showSuccess('Deleted'));
  }

  Future<String?> pickImage(String folder) async {
    final res = await _storageService.pickImage();
    return res.fold((e) {
      Helpers.showError(e);
      return null;
    }, (file) async {
      if (file == null) return null;
      final path = '$folder/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final up = await _storageService.uploadImage(file: file, path: path);
      return up.fold((e) {
        Helpers.showError(e);
        return null;
      }, (url) => url);
    });
  }
}
