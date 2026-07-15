import 'package:get/get.dart';

import '../app/constants/app_constants.dart';
import '../app/utils/helpers.dart';
import '../data/models/order_model.dart';
import '../services/firestore_service.dart';

/// Platform-wide order oversight: filter by status, advance/refund, search.
class OrdersController extends GetxController {
  final FirestoreService _firestoreService;

  OrdersController(this._firestoreService);

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxString statusFilter = 'all'.obs;
  final RxString search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _firestoreService.ordersStream().listen((list) => orders.value = list);
  }

  List<OrderModel> get filtered {
    var list = orders.toList();
    if (statusFilter.value != 'all') {
      list = list.where((o) => o.status == statusFilter.value).toList();
    }
    final q = search.value.toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((o) =>
              o.customerName.toLowerCase().contains(q) ||
              o.restaurantName.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Future<void> updateStatus(OrderModel order, String status) async {
    final updated = order.copyWith(status: status);
    final res = await _firestoreService.updateOrder(updated);
    res.fold((e) => Helpers.showError(e),
        (_) => Helpers.showSuccess('Status → $status'));
  }

  Future<void> cancelOrder(OrderModel order) async {
    final ok = await Helpers.confirm(
        title: 'Cancel order', message: 'Cancel this order?');
    if (!ok) return;
    await updateStatus(order, AppConstants.orderCancelled);
  }
}
