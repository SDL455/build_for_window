import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';

/// Global, permanent singletons for the admin console.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(FirestoreService(), permanent: true);
    Get.put(StorageService(), permanent: true);
    Get.put(
      AuthController(Get.find<AuthService>(), Get.find<FirestoreService>()),
      permanent: true,
    );
  }
}
