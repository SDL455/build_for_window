import 'package:foodpanda_admin/app/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../views/splash/splash_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/dashboard/dashboard_view.dart';
import '../../views/users/users_view.dart';
import '../../views/restaurants/restaurants_view.dart';
import '../../views/orders/orders_view.dart';
import '../../views/profile/profile_view.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/users_controller.dart';
import '../../controllers/restaurants_controller.dart';
import '../../controllers/orders_controller.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => SplashView()),
    GetPage(name: AppRoutes.login, page: () => LoginView()),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: BindingsBuilder(() =>
          Get.lazyPut(() => DashboardController(Get.find<FirestoreService>()))),
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => const UsersView(),
      binding: BindingsBuilder(() =>
          Get.lazyPut(() => UsersController(Get.find<FirestoreService>()))),
    ),
    GetPage(
      name: AppRoutes.restaurants,
      page: () => const RestaurantsView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => RestaurantsController(
            Get.find<FirestoreService>(),
            Get.find<StorageService>(),
          ))),
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersView(),
      binding: BindingsBuilder(() =>
          Get.lazyPut(() => OrdersController(Get.find<FirestoreService>()))),
    ),
    GetPage(name: AppRoutes.profile, page: () => const ProfileView()),
  ];
}
