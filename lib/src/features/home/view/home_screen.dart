import 'package:copybox/src/core/constants/app_routes.dart';
import 'package:copybox/src/core/global/navigator_key.dart';
import 'package:copybox/src/features/home/model/clipboard_item.dart';
import 'package:copybox/src/features/home/view/widgets/filter_dialog.dart';
import 'package:copybox/src/features/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFC8D4),
      body: ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        builder: (context, child) => Consumer<HomeViewModel>(
          builder: (context, viewModel, child) => SafeArea(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0.w),
              child: Column(
                children: [
                  /// App bar
                  _appBar(
                    viewModel,
                  ),
                  SizedBox(height: 18.h),

                  /// Search bar
                  _searchBar(),
                  SizedBox(height: 18.h),

                  /// Top buttons
                  _topButtons(),
                  SizedBox(height: 18.h),

                  Expanded(
                    child: ValueListenableBuilder<List<ClipboardItem>>(
                      valueListenable: viewModel.clipboardItems,
                      builder: (_, items, __) => ListView.separated(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _noteCard(
                            title: item.title,
                            content: item.content,
                            tag: item.category ?? 'add category',
                            time: item.createdAt.toString(),
                            viewModel: viewModel,
                            id: item.id.toString(),
                          );
                        },
                        separatorBuilder: (context, index) => 12.0.h.verticalSpace,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// App Bar
  Widget _appBar(HomeViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "CopyBox",
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0B2230),
          ),
        ),
        Row(
          children: [
            ValueListenableBuilder(
              valueListenable: viewModel.isServiceActive,
              builder: (_, isActive, __) => IconButton(
                onPressed: viewModel.openAccessibilitySettings,
                icon: Icon(
                  Icons.radio_button_checked,
                  size: 30.sp,
                  color: isActive ? Colors.green : Colors.red,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                navigatorKey.currentContext?.push(AppRoutes.settings);
              },
              icon: Icon(
                Icons.settings,
                size: 30.sp,
                color: const Color(0xFF072137),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "search",
                hintStyle: TextStyle(fontSize: 16.sp),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_alt_rounded, size: 23.sp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const FilterDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _topButtons() {
    final filters = ["all", "facebook", "instagram", "secret keys", "+"];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map(_filterButton).toList(),
      ),
    );
  }

  Widget _filterButton(String text) {
    final isSelected = false;

    return Padding(
      padding: EdgeInsets.only(right: 6.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () {
          setState(() {
            // selected = text;
          });
        },
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E4A5A) : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateWidget() {
    final now = DateTime.now();
    final formattedDate = "${now.day.toString().padLeft(2, '0')} "
        "${_monthName(now.month)}, ${now.year}, ${_weekDayName(now.weekday)}";

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2E4A5A),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        formattedDate,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp,
        ),
      ),
    );
  }

  String _monthName(int month) => ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][month - 1];

  String _weekDayName(int day) => ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][day - 1];

  Widget _noteCard({
    required String title,
    required String content,
    required String tag,
    required String time,
    required String id,
    required HomeViewModel viewModel,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF5E7787),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(title, style: TextStyle(color: Colors.white70, fontSize: 14.sp))),
            GestureDetector(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Copied to clipboard'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Icon(Icons.copy, color: Colors.white70, size: 18.sp)),
            10.0.w.horizontalSpace,
            GestureDetector(
                onTap: () {
                  debugPrint('Id from Ui is : $id');
                  viewModel.deleteClipboardItem(id);
                },
                child: Icon(Icons.delete_outline, color: Colors.white70, size: 20.sp)),
          ]),
          SizedBox(height: 10.h),
          Text(content, style: TextStyle(color: Colors.white, fontSize: 15.sp)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.all(8.0.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                  ),
                  child: Text(tag, style: TextStyle(color: Colors.black, fontSize: 10.sp))),
              Text(time, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            ],
          ),
        ],
      ),
    );
  }
}
