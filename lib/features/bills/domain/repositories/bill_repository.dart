import '../entities/bill_entity.dart';

abstract class BillRepository {
  Future<List<BillEntity>> getBills(String token, String? type);
}