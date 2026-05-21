
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePayment {
  final PaymentRepository repo;

  CreatePayment(this.repo);

  Future<PaymentEntity> call({
    required double amount,
    required String provider,
    required String purpose,
    required String token,
  }) {
    return repo.createPayment(
      amount: amount,
      provider: provider,
      purpose: purpose,
      token: token,
    );
  }
}