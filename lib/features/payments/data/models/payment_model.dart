import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  PaymentModel({
    required super.amount,
    required super.provider,
    required super.purpose,
    super.id,
    super.checkoutUrl,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json["payment"]?["_id"],
      amount: (json["payment"]?["amount"] ?? 0).toDouble(),
      provider: json["payment"]?["provider"] ?? "",
      purpose: json["payment"]?["purpose"] ?? "",
      checkoutUrl: json["checkoutUrl"],
    );
  }
}