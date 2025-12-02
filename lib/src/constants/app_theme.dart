import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Màu sắc tương phản cao
  static const Color primaryGreen = Color(0xFF2E7D32); // Xanh lá đậm (Tiền vào)
  static const Color primaryRed = Color(0xFFC62828); // Đỏ đậm (Nợ/Chi)
  static const Color backgroundWhite = Colors.white;
  static const Color textBlack = Colors.black;
  
  static ThemeData get bigTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
      ),
      // Cấu hình chữ TO mặc định
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: textBlack),
        displayMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: textBlack),
        bodyLarge: TextStyle(fontSize: 20.sp, color: textBlack), // Cỡ chữ thường dùng
        bodyMedium: TextStyle(fontSize: 18.sp, color: textBlack),
        labelLarge: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), // Nút bấm
      ),
      // Cấu hình nút bấm TO
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }
}
