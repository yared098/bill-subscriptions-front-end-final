abstract class PaymentEvent {}

class CreatePaymentEvent extends PaymentEvent {
  final double amount;
  final String provider;
  final String purpose;
  final String token;

  CreatePaymentEvent({
    required this.amount,
    required this.provider,
    required this.purpose,
    required this.token,
  });
}