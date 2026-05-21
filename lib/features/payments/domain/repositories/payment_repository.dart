import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<PaymentEntity> createPayment({
    required double amount,
    required String provider,
    required String purpose,
    required String token,
  });
}