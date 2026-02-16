import 'package:copybox/src/features/language/view/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFADB6C4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 31.h,
                left: 27.w,
                right: 177.w,
              ),
              child: SizedBox(
                width: 156.w,
                height: 48.h,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0B2230),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 49.h),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 27.w),
                itemCount: settingsItems.length,
                separatorBuilder: (_, __) => SizedBox(height: 13.h),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = index);

                      Future.delayed(const Duration(milliseconds: 150), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => settingsItems[index]['screen'],
                          ),
                        );

                        Future.delayed(const Duration(milliseconds: 200), () {
                          if (mounted) {
                            setState(() => selectedIndex = null);
                          }
                        });
                      });
                    },
                    child: Container(
                      width: 311.w,
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E7787).withOpacity(0.35),
                        borderRadius: BorderRadius.circular(7.r),
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF001B2E),
                                width: 1.w,
                              )
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 159.w,
                            height: 23.h,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                settingsItems[index]['title'],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> settingsItems = [
    {'title': 'Language', 'screen': const LanguageScreen()},
    // {'title': 'Privacy Policy', 'screen': const PlaceholderScreen(title: 'Privacy Policy')},
    // {'title': 'Rate & Feedback', 'screen': const PlaceholderScreen(title: 'Rate & Feedback')},
    // {'title': 'Terms & Conditions', 'screen': const PlaceholderScreen(title: 'Terms & Conditions')},
    // {'title': 'Contact Us', 'screen': const PlaceholderScreen(title: 'Contact Us')},
  ];
}
