import '../../domain/entities/payment_entity.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentEntity payment;

  PaymentSuccess(this.payment);
}

class PaymentFailure extends PaymentState {
  final String message;

  PaymentFailure(this.message);
}