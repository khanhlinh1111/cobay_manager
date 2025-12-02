import 'package:isar/isar.dart';

// Cmd chạy code generation: flutter pub run build_runner build
part 'customer.g.dart';

@collection
class Customer {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false) // Tìm kiếm không phân biệt hoa thường
  late String name;

  String? phoneNumber;

  double totalDebt = 0; // Tổng nợ

  DateTime? lastVisit;
}
