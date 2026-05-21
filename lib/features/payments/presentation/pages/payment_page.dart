import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_payment.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../data/datasources/payment_remote_datasource.dart';

import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class PaymentPage extends StatelessWidget {
  final String token;

  const PaymentPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(
        CreatePayment(
          PaymentRepositoryImpl(
            PaymentRemoteDataSource(),
          ),
        ),
      ),

      child: Scaffold(
        appBar: AppBar(title: const Text("Payments")),

        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              if (state.payment.checkoutUrl != null) {
                debugPrint(state.payment.checkoutUrl);
              }
            }
          },

          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is PaymentLoading)
                    const CircularProgressIndicator(),

                  ElevatedButton(
                    onPressed: () {
                      context.read<PaymentBloc>().add(
                            CreatePaymentEvent(
                              amount: 100,
                              provider: "chapa",
                              purpose: "bill",
                              token: token,
                            ),
                          );
                    },
                    child: const Text("Pay Now"),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      context.read<PaymentBloc>().add(
                            CreatePaymentEvent(
                              amount: 500,
                              provider: "chapa",
                              purpose: "bill",
                              token: token,
                            ),
                          );
                    },
                    child: const Text("Pay All Bills"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}