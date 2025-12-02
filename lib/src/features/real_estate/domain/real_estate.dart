import 'package:isar/isar.dart';

part 'real_estate.g.dart';

@collection
class RealEstate {
  Id id = Isar.autoIncrement;

  late DateTime createdDate;

  @Index()
  double price = 0;

  String? address; // Địa chỉ ngắn gọn

  @Index(type: IndexType.value, caseSensitive: false) // Full-text search (Simulated via value index)
  String? description; 

  List<String>? photoPaths; // Lưu đường dẫn file ảnh trên máy
  
  String? ownerName;
  String? ownerPhone;
}
