import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 420.w,
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundColor: AppTheme.primaryLight,
                    child: const Icon(Icons.admin_panel_settings,
                        color: AppTheme.primary, size: 34),
                  ),
                  SizedBox(height: 16.h),
                  Text('Admin Console',
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.h),
                  const Text('Sign in with your admin account',
                      style: TextStyle(color: AppTheme.textSecondary)),
                  SizedBox(height: 24.h),
                  _field(
                    label: 'Email',
                    controller: _email,
                    icon: Icons.email_outlined,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  _field(
                    label: 'Password',
                    controller: _password,
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: auth.isLoading.value
                              ? null
                              : () {
                                  if (_form.currentState!.validate()) {
                                    auth.login(
                                        email: _email.text,
                                        password: _password.text);
                                  }
                                },
                          child: auth.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white)),
                                )
                              : const Text('Sign in'),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary)),
          ),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: label,
            ),
          ),
        ],
      ),
    );
  }
}
