import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_theme.dart';

class RealEstateScreen extends StatelessWidget {
  const RealEstateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data (Sau này thay bằng Isar)
    final lands = [
      {'price': '2.5 Tỷ', 'desc': 'Mặt tiền đường nhựa, gần chợ'},
      {'price': '850 Tr', 'desc': 'Đất vườn 500m2, có sổ'},
      {'price': '5 Tỷ', 'desc': 'Nhà lầu 2 tấm, khu dân cư'},
      {'price': '1.2 Tỷ', 'desc': 'Đất nền dự án'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("KHO ĐẤT", style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24.sp)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 32.sp, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.8,
          ),
          itemCount: lands.length,
          itemBuilder: (context, index) {
            final item = lands[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh Placeholder
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                        color: Colors.grey.shade300,
                      ),
                      child: Center(child: Icon(Icons.image, size: 50.sp, color: Colors.grey)),
                    ),
                  ),
                  // Thông tin
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade700,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              item['price']!,
                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item['desc']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // Nút thêm đất (để ở góc phải dưới, không đụng hàng với nút Voice ở giữa)
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "add_land_btn", // Tránh lỗi Hero với nút ở Dashboard
        onPressed: () {},
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add_a_photo),
        label: Text("THÊM ĐẤT", style: TextStyle(fontSize: 18.sp)),
      ),
    );
  }
}
