import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remote;

  PaymentRepositoryImpl(this.remote);

  @override
  Future<PaymentEntity> createPayment({
    required double amount,
    required String provider,
    required String purpose,
    required String token,
  }) async {
    final res = await remote.createPayment(
      amount: amount,
      provider: provider,
      purpose: purpose,
      token: token,
    );

    return PaymentModel.fromJson(res);
  }
}