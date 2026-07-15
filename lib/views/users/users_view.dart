import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../app/constants/app_constants.dart';
import '../../app/theme/app_theme.dart';
import '../../app/utils/helpers.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/users_controller.dart';
import '../../data/models/user_model.dart';
import '../../widgets/admin_shell.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UsersController>();
    return AdminShell(
      title: 'Users',
      actions: [
        IconButton(
          icon: const Icon(Icons.person_add),
          tooltip: 'Add user',
          onPressed: () => _showAddDialog(context, ctrl),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Search + role filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => ctrl.search.value = v,
                    decoration: const InputDecoration(
                      hintText: 'Search name or email...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                _roleDropdown(ctrl),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                final list = ctrl.filtered;
                if (list.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (_, i) => _userTile(list[i], ctrl),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleDropdown(UsersController ctrl) {
    final roles = [
      {'v': 'all', 'l': 'All roles'},
      {'v': 'customer', 'l': 'Customers'},
      {'v': 'merchant', 'l': 'Merchants'},
      {'v': 'rider', 'l': 'Riders'},
    ];
    return Obx(() => DropdownButton2<String>(
          value: ctrl.roleFilter.value,
          items: roles
              .map((r) => DropdownMenuItem(
                  value: r['v'], child: Text(r['l']!)))
              .toList(),
          onChanged: (v) => ctrl.roleFilter.value = v ?? 'all',
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            height: 48.h,
            width: 160.w,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppTheme.divider),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(height: 44),
        ));
  }

  Widget _userTile(UserModel u, UsersController ctrl) {
    final color = u.isCustomer
        ? AppTheme.info
        : u.isMerchant
            ? AppTheme.accent
            : AppTheme.primary;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: color.withOpacity(0.12),
            child: Text(Helpers.initials(u.fullName),
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(u.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 2.h),
                Text(u.email, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                SizedBox(height: 2.h),
                Text(u.phone, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(u.role,
                style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          SizedBox(width: 8.w),
          if (u.role != 'admin')
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppTheme.error),
              onPressed: () => ctrl.remove(u),
            ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, UsersController ctrl) {
    final name = TextEditingController();
    final email = TextEditingController();
    final pass = TextEditingController();
    final phone = TextEditingController();
    final store = TextEditingController();
    final role = 'customer'.obs;

    Helpers.showFormDialog(
      title: 'Add user',
      confirmText: 'Create',
      fields: [
        TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'Full name'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: email,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: pass,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password (min 6)'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: phone,
          decoration: const InputDecoration(labelText: 'Phone'),
        ),
        const SizedBox(height: 10),
        Obx(() => DropdownButtonFormField2<String>(
              value: role.value,
              items: const [
                DropdownMenuItem(value: 'customer', child: Text('Customer')),
                DropdownMenuItem(value: 'merchant', child: Text('Merchant')),
                DropdownMenuItem(value: 'rider', child: Text('Rider')),
              ],
              onChanged: (v) => role.value = v!,
              decoration: const InputDecoration(labelText: 'Role'),
            )),
        Obx(() => role.value == 'merchant'
            ? Column(
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: store,
                    decoration: const InputDecoration(labelText: 'Restaurant name'),
                  ),
                ],
              )
            : const SizedBox.shrink()),
      ],
      onSubmit: () async {
        if (name.text.isEmpty || email.text.isEmpty || pass.text.length < 6) {
          Helpers.showError('Fill required fields (password ≥ 6 chars).');
          return false;
        }
        final res = await Get.find<AuthController>().createUser(
          fullName: name.text,
          email: email.text,
          password: pass.text,
          phone: phone.text,
          role: role.value,
          restaurantName: store.text.isEmpty ? null : store.text,
        );
        return res.fold((e) {
          Helpers.showError(e);
          return false;
        }, (_) {
          Helpers.showSuccess('User created');
          return true;
        });
      },
    );
  }
}
