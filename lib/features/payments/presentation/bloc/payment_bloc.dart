import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_event.dart';
import 'payment_state.dart';
import '../../domain/usecases/create_payment.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePayment createPayment;

  PaymentBloc(this.createPayment) : super(PaymentInitial()) {
    on<CreatePaymentEvent>(_onCreate);
  }

  Future<void> _onCreate(
    CreatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final payment = await createPayment(
        amount: event.amount,
        provider: event.provider,
        purpose: event.purpose,
        token: event.token,
      );

      emit(PaymentSuccess(payment));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}