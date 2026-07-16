import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../app/constants/app_constants.dart';
import '../app/routes/app_routes.dart';
import '../app/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

/// Reusable admin screen shell with a navigation drawer.
class AdminShell extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AdminShell({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      drawer: const AdminDrawer(),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthController>().user;
    final isAdmin = user?.role == AppConstants.roleAdmin;
    final items = [
      _DrawerItem(Icons.dashboard_rounded, 'Dashboard', AppRoutes.dashboard),
      if (isAdmin)
        _DrawerItem(Icons.people_alt_rounded, 'Users', AppRoutes.users),
      _DrawerItem(Icons.storefront_rounded, 'Restaurants', AppRoutes.restaurants),
      _DrawerItem(Icons.receipt_long_rounded, 'Orders', AppRoutes.orders),
      _DrawerItem(Icons.person_rounded, 'Profile', AppRoutes.profile),
    ];
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 20.h),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: Colors.white,
                  child: Text(
                    user != null ? _initials(user.fullName) : 'A',
                    style: const TextStyle(
                        color: AppTheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(user?.fullName ?? 'Admin',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(user?.email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              children: items
                  .map((it) => ListTile(
                        leading: Icon(it.icon, color: AppTheme.primary),
                        title: Text(it.label),
                        onTap: () {
                          if (Get.currentRoute != it.route) {
                            Get.offNamedUntil(it.route, (r) => false);
                          } else {
                            Get.back();
                          }
                        },
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.error),
            title: const Text('Sign out',
                style: TextStyle(color: AppTheme.error)),
            onTap: () => Get.find<AuthController>().logout(),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.isEmpty) return 'A';
    if (p.length == 1) return p[0][0].toUpperCase();
    return (p[0][0] + p[1][0]).toUpperCase();
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final String route;
  const _DrawerItem(this.icon, this.label, this.route);
}
