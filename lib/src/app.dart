import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/app_theme.dart';

import 'features/dashboard/dashboard_screen.dart';

class CoBayManagerApp extends StatelessWidget {
  const CoBayManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo ScreenUtil để responsive theo thiết kế 360x690 (Kích thước Android phổ thông)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cô Bảy Quản Lý',
          theme: AppTheme.bigTheme, // Dùng theme chữ to
          home: const DashboardScreen(),
        );
      },
    );
  }
}
