import 'package:intl/intl.dart';

enum VoiceIntent {
  addDebt,    // Ghi nợ
  payDebt,    // Trả nợ
  addIncome,  // Thu tiền (dịch vụ)
  unknown,    // Không hiểu
}

class VoiceAction {
  final VoiceIntent intent;
  final String? customerName;
  final double amount;
  final String originalText;

  VoiceAction({
    required this.intent,
    this.customerName,
    this.amount = 0,
    required this.originalText,
  });

  @override
  String toString() {
    return 'Intent: $intent, Name: $customerName, Amount: $amount';
  }
}

class VoiceCommandProcessor {
  // Các từ khóa nhận diện
  static const _debtKeywords = ['nợ', 'thiếu', 'chưa trả', 'ghi sổ'];
  static const _payKeywords = ['trả', 'đưa', 'đóng', 'gửi'];
  static const _units = {
    'k': 1000.0,
    'nghìn': 1000.0,
    'ngàn': 1000.0,
    'trăm': 100000.0, // "2 trăm" = 200k
    'xị': 100000.0,
    'triệu': 1000000.0,
    'chai': 1000000.0,
    'củ': 1000000.0,
  };

  VoiceAction processText(String input) {
    String text = input.toLowerCase();
    
    // 1. Xác định Intent
    VoiceIntent intent = VoiceIntent.addIncome; // Mặc định là thu tiền dịch vụ
    if (_containsAny(text, _debtKeywords)) {
      intent = VoiceIntent.addDebt;
    } else if (_containsAny(text, _payKeywords)) {
      intent = VoiceIntent.payDebt;
    }

    // 2. Bóc tách số tiền
    double amount = _extractAmount(text);

    // 3. Bóc tách tên (Logic đơn giản: Lấy chuỗi không phải số và từ khóa)
    String? name = _extractName(text);

    return VoiceAction(
      intent: intent,
      customerName: name,
      amount: amount,
      originalText: input,
    );
  }

  bool _containsAny(String text, List<String> keywords) {
    for (var word in keywords) {
      if (text.contains(word)) return true;
    }
    return false;
  }

  double _extractAmount(String text) {
    double total = 0;
    
    // Regex tìm số (ví dụ: 500, 200)
    RegExp numberRegExp = RegExp(r'(\d+([.,]\d+)?)');
    Match? match = numberRegExp.firstMatch(text);
    
    if (match != null) {
      double number = double.parse(match.group(1)!.replaceAll(',', '.'));
      
      // Kiểm tra đơn vị đi kèm
      double multiplier = 1000; // Mặc định nếu chỉ nói số (500 -> 500k)
      
      _units.forEach((unit, value) {
        if (text.contains(unit)) {
          multiplier = value;
          // Xử lý trường hợp "trăm rưỡi" -> 1.5
          if (text.contains('$unit rưỡi')) {
             number = number + 0.5; 
             // Ví dụ: "một trăm rưỡi" -> 1.5 * 100,000 = 150,000
             // Nhưng logic này cần xử lý số từ ngữ (một, hai...) phức tạp hơn.
             // Ở đây ta giả định người dùng nói "1 trăm rưỡi" (số 1)
          }
        }
      });
      
      // Đặc biệt: Nếu nói "trăm" mà không có số, hoặc số < 10 -> Nhân logic khác
      if (multiplier == 100000.0 && number < 10) {
         // "2 trăm" -> 200,000
         // Đã cover bởi multiplier
      }
       else if (multiplier == 1000 && number < 1000) {
        // "500" -> 500,000 (ngầm hiểu nghìn)
        // "500 k" -> 500,000
      }

      total = number * multiplier;
    }
    
    return total;
  }

  String? _extractName(String text) {
    // Đây là phần khó nhất trong NLP nếu không có model xịn.
    // Logic đơn giản: Loại bỏ các từ khóa, số, đơn vị tiền -> Còn lại là tên.
    
    String temp = text;
    // Xóa số
    temp = temp.replaceAll(RegExp(r'\d+'), '');
    // Xóa keywords
    for (var k in _debtKeywords) temp = temp.replaceAll(k, '');
    for (var k in _payKeywords) temp = temp.replaceAll(k, '');
    for (var k in _units.keys) temp = temp.replaceAll(k, '');
    
    // Xóa các từ nối
    var stopWords = ['cho', 'của', 'bà', 'chị', 'em', 'anh', 'thằng', 'con', 'ghi', 'nhớ', 'nha', 'nhé'];
    for (var w in stopWords) temp = temp.replaceAll(w, '');

    return temp.trim().split(' ').last; // Lấy từ cuối cùng làm tên (Ví dụ "Nguyễn Văn A" -> "A")
  }
}
