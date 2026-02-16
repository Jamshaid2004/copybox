import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int selectedIndex = 0;

  final List<Map<String, String>> languages = [
    {'title': 'English (US)', 'flag': 'assets/images/us.png'},
    {'title': 'Spanish', 'flag': 'assets/images/spanish.png'},
    {'title': 'French', 'flag': 'assets/images/french.png'},
    {'title': 'Hindi', 'flag': 'assets/images/india.png'},
    {'title': 'Portuguese', 'flag': 'assets/images/portugues.png'},
  ];

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
                    'Language',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF001B2E),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 49.h),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                itemCount: languages.length,
                separatorBuilder: (_, __) => SizedBox(height: 13.h),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = index);
                    },
                    child: Container(
                      width: 311.w,
                      height: index == 0 ? 49.h : 50.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E7787).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(7.r),
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF001B2E),
                                width: 1.w,
                              )
                            : null,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 159.w,
                            height: 23.h,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                languages[index]['title']!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Image.asset(
                            languages[index]['flag']!,
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.cover,
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
}
