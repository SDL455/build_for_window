import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/auth_layout.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return AuthLayout(
      title: 'Sign in',
      subtitle: 'Welcome back, please enter your admin credentials.',
      features: const [
        'Real-time orders & revenue analytics',
        'Manage customers, merchants & riders',
        'Approve restaurants and oversee deliveries',
      ],
      form: Form(
        key: _form,
        child: Column(
          children: [
            _field(
              label: 'Email',
              controller: _email,
              icon: Icons.email_outlined,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            Obx(() => _field(
                  label: 'Password',
                  controller: _password,
                  icon: Icons.lock_outline,
                  obscure: auth.obscurePassword.value,
                  toggle: () => auth.togglePassword(),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                )),
            SizedBox(height: 8.h),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading.value
                        ? null
                        : () {
                            if (_form.currentState!.validate()) {
                              auth.login(
                                  email: _email.text, password: _password.text);
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
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: const Text("Don't have an admin account? ",
                      style: TextStyle(color: AppTheme.textSecondary)),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.register),
                  child: Text('Create one',
                      style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    VoidCallback? toggle,
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
              suffixIcon: toggle != null
                  ? IconButton(
                      icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: toggle,
                    )
                  : null,
              hintText: label,
            ),
          ),
        ],
      ),
    );
  }
}
