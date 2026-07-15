import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../app/theme/app_theme.dart';
import '../../app/utils/helpers.dart';
import '../../controllers/restaurants_controller.dart';
import '../../data/models/restaurant_model.dart';
import '../../widgets/admin_shell.dart';
import '../../widgets/net_image.dart';

class RestaurantsView extends StatelessWidget {
  const RestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<RestaurantsController>();
    return AdminShell(
      title: 'Restaurants',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Add restaurant',
          onPressed: () => _showForm(context, ctrl, null),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            TextField(
              onChanged: ctrl.onSearch,
              decoration: const InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                final list = ctrl.filtered;
                if (list.isEmpty) {
                  return const Center(child: Text('No restaurants found.'));
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

  Widget _tile(RestaurantModel r, RestaurantsController ctrl) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          NetImage(url: r.imageUrl, width: 64.w, height: 64.h, radius: 12),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 2.h),
                Text(r.categoryName ?? 'Uncategorized',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    _badge(r.isApproved ? 'Approved' : 'Pending',
                        r.isApproved ? AppTheme.success : AppTheme.warning),
                    SizedBox(width: 6.w),
                    _badge(r.isOpen ? 'Open' : 'Closed',
                        r.isOpen ? AppTheme.info : Colors.grey),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => _showForm(Get.context!, ctrl, r),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline, size: 18),
            color: r.isApproved ? AppTheme.success : AppTheme.textSecondary,
            onPressed: () => ctrl.toggleApproval(r),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.error),
            onPressed: () => ctrl.delete(r),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  void _showForm(BuildContext context, RestaurantsController ctrl, RestaurantModel? existing) {
    final name = TextEditingController(text: existing?.name ?? '');
    final desc = TextEditingController(text: existing?.description ?? '');
    final cat = TextEditingController(text: existing?.categoryName ?? '');
    final fee = TextEditingController(text: existing?.deliveryFee.toString() ?? '2.0');
    final time = TextEditingController(text: existing?.deliveryTimeMin.toString() ?? '30');
    final approved = (existing?.isApproved ?? true).obs;
    final imageUrl = (existing?.imageUrl ?? '').obs;

    Helpers.showFormDialog(
      title: existing == null ? 'Add restaurant' : 'Edit restaurant',
      confirmText: existing == null ? 'Create' : 'Update',
      fields: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
        const SizedBox(height: 10),
        TextField(controller: desc, decoration: const InputDecoration(labelText: 'Description')),
        const SizedBox(height: 10),
        TextField(controller: cat, decoration: const InputDecoration(labelText: 'Category')),
        const SizedBox(height: 10),
        TextField(controller: fee, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Delivery fee')),
        const SizedBox(height: 10),
        TextField(controller: time, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Delivery time (min)')),
        const SizedBox(height: 10),
        Obx(() => SwitchListTile(
              title: const Text('Approved'),
              value: approved.value,
              activeColor: AppTheme.primary,
              onChanged: (v) => approved.value = v,
            )),
        Obx(() => TextButton.icon(
              onPressed: () async {
                final url = await ctrl.pickImage('restaurants');
                if (url != null) imageUrl.value = url;
              },
              icon: const Icon(Icons.image),
              label: Text(imageUrl.value.isEmpty ? 'Add photo' : 'Change photo'),
            )),
      ],
      onSubmit: () async {
        if (name.text.isEmpty) {
          Helpers.showError('Name is required.');
          return false;
        }
        final ok = await ctrl.save(
          name: name.text.trim(),
          description: desc.text.trim(),
          categoryName: cat.text.trim(),
          deliveryFee: double.tryParse(fee.text) ?? 2.0,
          deliveryTimeMin: int.tryParse(time.text) ?? 30,
          isApproved: approved.value,
          existing: existing,
          imageUrl: imageUrl.value.isEmpty ? null : imageUrl.value,
        );
        return ok;
      },
    );
  }
}
