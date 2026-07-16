import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../app/utils/helpers.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../widgets/admin_shell.dart';
import '../../widgets/stat_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DashboardController>();
    return AdminShell(
      title: 'Dashboard',
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              SizedBox(height: 20.h),
              // KPI cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: _cols(context),
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.w,
                childAspectRatio: 1.6,
                children: [
                  StatCard(
                    label: 'Total revenue',
                    value: Helpers.formatCurrency(ctrl.totalRevenue),
                    icon: Icons.attach_money,
                    color: AppTheme.success,
                  ),
                  StatCard(
                    label: 'Orders',
                    value: ctrl.totalOrders.toString(),
                    icon: Icons.receipt_long,
                    color: AppTheme.info,
                  ),
                  StatCard(
                    label: 'Active orders',
                    value: ctrl.activeOrders.toString(),
                    icon: Icons.hourglass_top,
                    color: AppTheme.warning,
                  ),
                  StatCard(
                    label: 'Customers',
                    value: ctrl.totalCustomers.toString(),
                    icon: Icons.people,
                    color: AppTheme.primary,
                  ),
                  StatCard(
                    label: 'Merchants',
                    value: ctrl.totalMerchants.toString(),
                    icon: Icons.storefront,
                    color: AppTheme.accent,
                  ),
                  StatCard(
                    label: 'Riders',
                    value: ctrl.totalRiders.toString(),
                    icon: Icons.delivery_dining,
                    color: Colors.purple,
                  ),
                  StatCard(
                    label: 'Approved stores',
                    value: ctrl.approvedRestaurants.toString(),
                    icon: Icons.verified,
                    color: AppTheme.success,
                  ),
                  StatCard(
                    label: 'Pending stores',
                    value: ctrl.pendingRestaurants.toString(),
                    icon: Icons.pending,
                    color: AppTheme.warning,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // Revenue chart
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Revenue — last 7 days',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 16.h),
                    SizedBox(
                      height: 220.h,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _maxY(ctrl.revenueLast7Days),
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) => Text(
                                  _dayLabel(v.toInt()),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (v, _) => Text(
                                  '\$${v.toInt()}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: ctrl.revenueLast7Days
                              .asMap()
                              .entries
                              .map((e) => BarChartGroupData(
                                    x: e.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: e.value,
                                        color: AppTheme.primary,
                                        width: 18.w,
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              // Quick links
              Wrap(
                spacing: 12.w,
                runSpacing: 12.w,
                children: [
                  _quickLink('Manage users', Icons.people_alt, AppRoutes.users,
                      AppTheme.primary),
                  _quickLink('Manage restaurants', Icons.storefront,
                      AppRoutes.restaurants, AppTheme.accent),
                  _quickLink('Manage orders', Icons.receipt_long,
                      AppRoutes.orders, AppTheme.info),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  int _cols(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w > 1100) return 4;
    if (w > 700) return 3;
    if (w > 480) return 2;
    return 2;
  }

  double _maxY(List<double> data) {
    final m = data.isEmpty ? 10.0 : data.reduce((a, b) => a > b ? a : b);
    return (m <= 0 ? 10 : m) * 1.2;
  }

  String _dayLabel(int i) {
    final d = DateTime.now().subtract(Duration(days: 6 - i));
    return DateFormat('E').format(d);
  }

  Widget _header() {
    final user = Get.find<AuthController>().user;
    final now = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user != null
                    ? 'Welcome back, ${user.fullName.split(' ').first}'
                    : 'Welcome back',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(now, style: const TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Text('LIVE',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1)),
        ),
      ],
    );
  }

  Widget _quickLink(String label, IconData icon, String route, Color color) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      child: Container(
        width: 160.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            SizedBox(height: 10.h),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
