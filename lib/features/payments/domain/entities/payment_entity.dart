class PaymentEntity {
  final String? id;
  final double amount;
  final String provider;
  final String purpose;
  final String? checkoutUrl;

  PaymentEntity({
    this.id,
    required this.amount,
    required this.provider,
    required this.purpose,
    this.checkoutUrl,
  });
}