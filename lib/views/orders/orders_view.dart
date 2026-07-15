import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../app/constants/app_constants.dart';
import '../../app/theme/app_theme.dart';
import '../../app/utils/helpers.dart';
import '../../controllers/orders_controller.dart';
import '../../data/models/order_model.dart';
import '../../widgets/admin_shell.dart';
import '../../widgets/order_status_chip.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<OrdersController>();
    return AdminShell(
      title: 'Orders',
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => ctrl.search.value = v,
                    decoration: const InputDecoration(
                      hintText: 'Search customer or restaurant...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Obx(() => DropdownButton2<String>(
                      value: ctrl.statusFilter.value,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(value: 'pending', child: Text('Pending')),
                        DropdownMenuItem(value: 'accepted', child: Text('Accepted')),
                        DropdownMenuItem(value: 'preparing', child: Text('Preparing')),
                        DropdownMenuItem(value: 'ready', child: Text('Ready')),
                        DropdownMenuItem(value: 'picked_up', child: Text('On the way')),
                        DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                        DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                      ],
                      onChanged: (v) => ctrl.statusFilter.value = v ?? 'all',
                      buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        height: 48.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppTheme.divider),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(height: 44),
                    )),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                final list = ctrl.filtered;
                if (list.isEmpty) {
                  return const Center(child: Text('No orders found.'));
                }
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (_, i) => _tile(list[i], ctrl),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(OrderModel o, OrdersController ctrl) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(o.restaurantName, style: const TextStyle(fontWeight: FontWeight.w600))),
              OrderStatusChip(status: o.status),
            ],
          ),
          SizedBox(height: 4.h),
          Text('Customer: ${o.customerName}',
              style: const TextStyle(color: AppTheme.textSecondary)),
          Text('Items: ${o.items.map((i) => '${i.quantity}x ${i.name}').join(', ')}',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          SizedBox(height: 6.h),
          Row(
            children: [
              Text(Helpers.formatCurrency(o.total),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(width: 12.w),
              Text(Helpers.formatDate(o.createdAt),
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const Spacer(),
              TextButton(
                onPressed: () => _detail(o),
                child: const Text('Details'),
              ),
              if (o.status != 'delivered' && o.status != 'cancelled')
                PopupMenuButton<String>(
                  onSelected: (s) => ctrl.updateStatus(o, s),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'accepted', child: Text('Mark accepted')),
                    PopupMenuItem(value: 'preparing', child: Text('Mark preparing')),
                    PopupMenuItem(value: 'ready', child: Text('Mark ready')),
                    PopupMenuItem(value: 'picked_up', child: Text('Mark picked up')),
                    PopupMenuItem(value: 'delivered', child: Text('Mark delivered')),
                  ],
                  child: const Text('Advance'),
                ),
              if (o.status != 'delivered' && o.status != 'cancelled')
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: AppTheme.error),
                  onPressed: () => ctrl.cancelOrder(o),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _detail(OrderModel o) {
    Get.dialog(AlertDialog(
      title: Text(o.restaurantName),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderStatusChip(status: o.status),
            SizedBox(height: 10),
            Text('Customer: ${o.customerName}'),
            Text('Address: ${o.deliveryAddress ?? 'N/A'}'),
            Text('Payment: ${o.paymentMethod}'),
            const SizedBox(height: 8),
            ...o.items.map((i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${i.quantity}x ${i.name} — ${Helpers.formatCurrency(i.total)}'),
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(Helpers.formatCurrency(o.total),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Close')),
      ],
    ));
  }
}
