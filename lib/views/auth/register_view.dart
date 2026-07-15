import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../app/utils/helpers.dart';
import '../../app/utils/validators.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/auth_layout.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return AuthLayout(
      title: 'Create admin account',
      subtitle: 'Set up your administrator login to manage the platform.',
      features: const [
        'Full access to users, restaurants & orders',
        'Platform-wide analytics & reports',
        'Secure, role-restricted console',
      ],
      form: Form(
        key: _form,
        child: Column(
          children: [
            _field(
              label: 'Full name',
              controller: _name,
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            _field(
              label: 'Email',
              controller: _email,
              icon: Icons.email_outlined,
              validator: Validators.email,
            ),
            _field(
              label: 'Phone',
              controller: _phone,
              icon: Icons.phone_outlined,
              validator: Validators.phone,
            ),
            Obx(() => _field(
                  label: 'Password',
                  controller: _password,
                  icon: Icons.lock_outline,
                  obscure: auth.obscurePassword.value,
                  toggle: () => auth.togglePassword(),
                  validator: Validators.password,
                )),
            _field(
              label: 'Confirm password',
              controller: _confirm,
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) => Validators.confirmPassword(v, _password.text),
            ),
            SizedBox(height: 8.h),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading.value
                        ? null
                        : () {
                            if (_form.currentState!.validate()) {
                              auth.registerAdmin(
                                fullName: _name.text,
                                email: _email.text,
                                password: _password.text,
                                phone: _phone.text,
                              );
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
                        : const Text('Create account'),
                  ),
                )),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? ',
                    style: TextStyle(color: AppTheme.textSecondary)),
                GestureDetector(
                  onTap: () => Get.offNamed(AppRoutes.login),
                  child: Text('Sign in',
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
                      icon: Icon(obscure
                          ? Icons.visibility_off
                          : Icons.visibility),
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
