import 'package:isar/isar.dart';
import 'customer.dart';

part 'transaction.g.dart';

enum TransactionType {
  income, // Thu tiền
  expense, // Chi tiền
  debt, // Ghi nợ
  repayment // Trả nợ
}

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  late DateTime date;

  double amount = 0;

  @Enumerated(EnumType.name)
  late TransactionType type;

  String? note; // "Nhuộm tóc", "Trả nợ cũ"

  final customer = IsarLink<Customer>();
}
