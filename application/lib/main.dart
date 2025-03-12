import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:Meetyfi/core/constants/app_binding.dart';
import 'package:Meetyfi/core/routes/routes.dart';
import 'package:Meetyfi/core/theme/app_theme.dart';
import 'package:Meetyfi/core/utils/life_cycle_observe.dart';
import 'package:Meetyfi/features/manager/auth/signup/presentation/controller/signup_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(SignupController());
  Get.put(AppLifecycleObserver());
  runApp(MyApp());
}

void initServices() async {
  // Initialize other services
  await Get.putAsync(() async => AppLifecycleObserver());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Meetyfi',
          theme: AppTheme.darkThemeMode,
          initialBinding: AppBindings(),
          getPages: AppRoutes.appRoutes(),
        );
      },
    );
  }
}
