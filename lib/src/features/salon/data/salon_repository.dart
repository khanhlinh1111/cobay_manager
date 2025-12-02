import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/customer.dart';
import '../domain/transaction.dart';

part 'salon_repository.g.dart'; // File sinh tự động bởi Riverpod

class SalonRepository {
  final Isar isar;

  SalonRepository(this.isar);

  // 1. Lấy danh sách khách hàng đang nợ (TotalDebt > 0)
  Stream<List<Customer>> watchDebtors() {
    return isar.customers
        .filter()
        .totalDebtGreaterThan(0) // Query của Isar
        .sortByLastVisitDesc()
        .watch(fireImmediately: true);
  }

  // 2. Tìm khách hàng theo tên
  Future<Customer?> findCustomerByName(String name) async {
    return await isar.customers
        .filter()
        .nameEqualTo(name, caseSensitive: false)
        .findFirst();
  }

  // 3. Thêm giao dịch (Ghi nợ/Trả nợ)
  Future<void> addTransaction({
    required String customerName,
    required double amount,
    required TransactionType type,
    String? note,
  }) async {
    await isar.writeTxn(() async {
      // Tìm khách cũ hoặc tạo mới
      Customer? customer = await isar.customers
          .filter()
          .nameEqualTo(customerName, caseSensitive: false)
          .findFirst();

      if (customer == null) {
        customer = Customer()
          ..name = customerName
          ..totalDebt = 0
          ..lastVisit = DateTime.now();
        await isar.customers.put(customer);
      }

      // Tạo giao dịch
      final transaction = Transaction()
        ..amount = amount
        ..date = DateTime.now()
        ..type = type
        ..note = note
        ..customer.value = customer;

      await isar.transactions.put(transaction);
      
      // Cập nhật tổng nợ của khách
      if (type == TransactionType.debt) {
        customer.totalDebt += amount;
      } else if (type == TransactionType.repayment) {
        customer.totalDebt -= amount;
        if (customer.totalDebt < 0) customer.totalDebt = 0;
      } else if (type == TransactionType.income) {
        // Thu tiền dịch vụ thì không tính vào nợ, chỉ cập nhật ngày ghé
      }
      
      customer.lastVisit = DateTime.now();
      await isar.customers.put(customer);
      
      // Lưu link liên kết
      await transaction.customer.save();
    });
  }
  
  // 4. Tổng doanh thu ngày hôm nay
  Future<double> getTodayRevenue() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final transactions = await isar.transactions
        .filter()
        .dateBetween(startOfDay, endOfDay)
        .and()
        .typeEqualTo(TransactionType.income) // Chỉ tính tiền thu dịch vụ
        .findAll();
        
    return transactions.fold<double>(0.0, (sum, item) => sum + item.amount);
  }
}

// Provider để UI gọi tới Repository
@riverpod
SalonRepository salonRepository(SalonRepositoryRef ref) {
  // Lưu ý: isarProvider phải được override ở main.dart
  final isar = ref.watch(isarProvider);
  return SalonRepository(isar);
}

// Placeholder cho Provider Isar (Sẽ được override ở main.dart)
@riverpod
Isar isar(IsarRef ref) {
  throw UnimplementedError();
}
