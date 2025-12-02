import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_theme.dart';
import '../data/salon_repository.dart';
import '../domain/customer.dart';

// Provider để lấy danh sách khách nợ (Auto-refresh khi DB đổi)
final debtorListProvider = StreamProvider.autoDispose<List<Customer>>((ref) {
  final repository = ref.watch(salonRepositoryProvider);
  return repository.watchDebtors();
});

class SalonScreen extends ConsumerWidget {
  const SalonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtorsAsync = ref.watch(debtorListProvider);
    // Format tiền Việt Nam
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      appBar: AppBar(
        title: Text("SỔ NỢ TIỆM TÓC", style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24.sp)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppTheme.primaryGreen),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tổng nợ:", style: Theme.of(context).textTheme.bodyLarge),
                  debtorsAsync.when(
                    data: (debtors) {
                       double total = debtors.fold(0, (sum, item) => sum + item.totalDebt);
                       return Text(currencyFormat.format(total), 
                         style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppTheme.primaryGreen)
                       );
                    },
                    loading: () => const SizedBox(),
                    error: (_,__) => const Text("---"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text("DANH SÁCH:", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            
            Expanded(
              child: debtorsAsync.when(
                data: (debtors) {
                  if (debtors.isEmpty) {
                    return Center(child: Text("Không có ai nợ cả!", style: TextStyle(fontSize: 20.sp, color: Colors.grey)));
                  }
                  return ListView.builder(
                    itemCount: debtors.length,
                    itemBuilder: (context, index) {
                      final customer = debtors[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                radius: 24.r,
                                child: Text(customer.name.isNotEmpty ? customer.name[0].toUpperCase() : "?", 
                                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(customer.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                    Text(
                                      customer.lastVisit != null 
                                        ? DateFormat('dd/MM').format(customer.lastVisit!) 
                                        : "Khách mới", 
                                      style: TextStyle(color: Colors.grey, fontSize: 16.sp)
                                    ),
                                  ],
                                ),
                              ),
                              Text(currencyFormat.format(customer.totalDebt), 
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.primaryRed, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Lỗi tải dữ liệu: $err")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}