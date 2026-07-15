import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/theme/app_theme.dart';

class OrderStatusChip extends StatelessWidget {
  final String status;
  const OrderStatusChip({super.key, required this.status});

  static (String, Color) _resolve(String status) {
    switch (status) {
      case 'pending':
        return ('Pending', const Color(0xFFF59E0B));
      case 'accepted':
        return ('Accepted', const Color(0xFF3B82F6));
      case 'preparing':
        return ('Preparing', const Color(0xFF8B5CF6));
      case 'ready':
        return ('Ready', const Color(0xFF0EA5E9));
      case 'picked_up':
        return ('On the way', const Color(0xFF6366F1));
      case 'delivered':
        return ('Delivered', const Color(0xFF22C55E));
      case 'cancelled':
        return ('Cancelled', const Color(0xFFEF4444));
      default:
        return (status, AppTheme.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, color) = _resolve(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12.sp, fontWeight: FontWeight.w600)),
    );
  }
}
