import 'package:copybox/src/core/constants/colors.dart';
import 'package:copybox/src/features/splash/view_model/splash_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start the timer and navigate to the next screen
    SplashScreenViewModel.getInstance().startTimerAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 169.h),
            Center(
              child: Image.asset(
                'assets/images/archive.png',
                width: 75.w,
                height: 75.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 396.h),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFF0B2230),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
