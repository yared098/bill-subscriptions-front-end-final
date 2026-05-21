import '../../domain/entities/bill_entity.dart';
import '../../domain/repositories/bill_repository.dart';
import '../datasources/bill_remote_datasource.dart';
import '../models/bill_model.dart';

class BillRepositoryImpl implements BillRepository {
  final BillRemoteDataSource remote;

  BillRepositoryImpl(this.remote);

  @override
  Future<List<BillEntity>> getBills(
    String token,
    String? type,
  ) async {
    final res = await remote.getBills(token, type);

    return res.map<BillEntity>((json) {
      return BillModel.fromJson(json);
    }).toList();
  }
}