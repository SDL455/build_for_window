import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'firebase_options.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

final logger = Logger(printer: PrettyPrinter());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await GetStorage.init('fp_admin_auth');

  try {
    // 2. ປ່ຽນມາສົ່ງຄ່າ DefaultFirebaseOptions.currentPlatform ເຂົ້າໄປບ່ອນນີ້
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    logger.e('Firebase init failed: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1280, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'FoodPanda Admin',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppRoutes.splash,
          initialBinding: InitialBinding(),
          getPages: AppPages.routes,
          defaultTransition: Transition.fadeIn,
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('en', 'US'),
          builder: (ctx, widget) => ResponsiveBreakpoints.builder(
            child: widget!,
            breakpoints: const [
              Breakpoint(start: 0, end: 450, name: 'MOBILE'),
              Breakpoint(start: 451, end: 800, name: 'TABLET'),
              Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
              Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
        );
      },
    );
  }
}
