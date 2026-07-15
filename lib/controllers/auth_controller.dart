import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dartz/dartz.dart';
import '../app/constants/app_constants.dart';
import '../app/routes/app_routes.dart';
import '../app/utils/helpers.dart';
import '../data/models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthController extends GetxController {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  final _box = GetStorage(AppConstants.boxAuth);

  AuthController(this._authService, this._firestoreService);

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> boot() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    final user = await _authService.getUserModel(fbUser.uid);
    if (user == null || user.role != AppConstants.roleAdmin) {
      await _authService.logout();
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    currentUser.value = user;
    _persist(user);
    Get.offAllNamed(AppRoutes.dashboard);
  }

  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    final res = await _authService.login(email: email, password: password);
    isLoading.value = false;
    res.fold(
      (e) => Helpers.showError(e),
      (user) {
        currentUser.value = user;
        _persist(user);
        Get.offAllNamed(AppRoutes.dashboard);
      },
    );
  }

  Future<void> logout() async {
    final ok =
        await Helpers.confirm(title: 'Sign out', message: 'Are you sure?');
    if (!ok) return;
    await _authService.logout();
    _box.erase();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<Either<String, UserModel>> createUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String role,
    String? restaurantName,
  }) {
    return _authService.createUser(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      role: role,
      restaurantName: restaurantName,
    );
  }

  Future<Either<String, void>> updateCurrentUser(UserModel updated) async {
    final res = await _authService.updateUser(updated);
    res.fold((e) => Helpers.showError(e), (_) {
      currentUser.value = updated;
      _persist(updated);
    });
    return res;
  }

  void _persist(UserModel user) {
    _box.write(AppConstants.keyIsLoggedIn, true);
    _box.write(AppConstants.keyUserId, user.uid);
  }

  void togglePassword() => obscurePassword.toggle();

  UserModel? get user => currentUser.value;
}
