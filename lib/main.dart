import 'package:copybox/src/config/navigation/app_router.dart';
import 'package:copybox/src/features/splash/view_model/splash_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenViewModel()),
      ],
      builder: (context, child) => ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp.router(
          title: 'CopyBox',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
