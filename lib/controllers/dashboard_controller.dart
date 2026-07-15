import 'package:get/get.dart';

import '../data/models/order_model.dart';
import '../data/models/restaurant_model.dart';
import '../data/models/user_model.dart';
import '../services/firestore_service.dart';

/// Aggregates platform-wide metrics for the admin dashboard.
class DashboardController extends GetxController {
  final FirestoreService _firestoreService;

  DashboardController(this._firestoreService);

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _firestoreService.usersStream().listen((list) {
      users.value = list;
      isLoading.value = false;
    });
    _firestoreService.restaurantsStream().listen((list) => restaurants.value = list);
    _firestoreService.ordersStream().listen((list) => orders.value = list);
  }

  int get totalCustomers =>
      users.where((u) => u.role == 'customer').length;
  int get totalMerchants =>
      users.where((u) => u.role == 'merchant').length;
  int get totalRiders => users.where((u) => u.role == 'rider').length;
  int get approvedRestaurants =>
      restaurants.where((r) => r.isApproved).length;
  int get pendingRestaurants =>
      restaurants.where((r) => !r.isApproved).length;

  int get totalOrders => orders.length;
  int get activeOrders =>
      orders.where((o) => o.status != 'delivered' && o.status != 'cancelled').length;

  double get totalRevenue => orders
      .where((o) => o.status == 'delivered')
      .fold(0.0, (s, o) => s + o.total);

  /// Revenue per day for the last 7 days (oldest -> newest) for the chart.
  List<double> get revenueLast7Days {
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      final d = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      final sum = orders
          .where((o) =>
              o.status == 'delivered' &&
              o.createdAt.year == d.year &&
              o.createdAt.month == d.month &&
              o.createdAt.day == d.day)
          .fold(0.0, (s, o) => s + o.total);
      return sum;
    });
    return days;
  }

  int ordersForStatus(String status) =>
      orders.where((o) => o.status == status).length;
}
