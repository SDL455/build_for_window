import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/theme/app_theme.dart';

/// Web-style authentication layout: a gradient branding panel on the left
/// (wide screens) and the form card on the right. Mirrors a typical HTML admin
/// login template.
class AuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final List<String> features;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    this.features = const [],
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final wide = constraints.maxWidth >= 900;
        if (!wide) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    _BrandingHeader(compact: true),
                    SizedBox(height: 20.h),
                    _FormCard(title: title, subtitle: subtitle, form: form),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: Row(
            children: [
              Expanded(
                flex: 5,
                child: _BrandingPanel(features: features),
              ),
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.h),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 440.w),
                      child: _FormCard(
                          title: title, subtitle: subtitle, form: form),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BrandingHeader extends StatelessWidget {
  final bool compact;
  const _BrandingHeader({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(compact ? 10.w : 14.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(Icons.admin_panel_settings,
              color: Colors.white, size: compact ? 22.sp : 28.sp),
        ),
        SizedBox(width: 12.w),
        Text('FoodPanda Admin',
            style: TextStyle(
                fontSize: compact ? 18.sp : 20.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary)),
      ],
    );
  }
}

class _BrandingPanel extends StatelessWidget {
  final List<String> features;
  const _BrandingPanel({this.features = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(48.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Image.asset(
              'assets/images/background_icon.png',
              width: 56.w,
              height: 56.w,
            ),
          ),
          SizedBox(height: 24.h),
          Text('Control Center',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text(
            'Manage users, restaurants, orders and analytics for your '
            'entire FoodPanda platform from one place.',
            style: TextStyle(
                color: Colors.white.withOpacity(0.9), fontSize: 15.sp),
          ),
          SizedBox(height: 28.h),
          ...features.map((f) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 16),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(f,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 14.sp)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  const _FormCard(
      {required this.title, required this.subtitle, required this.form});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 6.h),
          Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary)),
          SizedBox(height: 24.h),
          form,
        ],
      ),
    );
  }
}
