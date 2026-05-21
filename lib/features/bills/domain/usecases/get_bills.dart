import '../entities/bill_entity.dart';
import '../repositories/bill_repository.dart';

class GetBills {
  final BillRepository repo;

  GetBills(this.repo);

  Future<List<BillEntity>> call(
    String token, {
    String? type,
  }) {
    return repo.getBills(token, type);
  }
}