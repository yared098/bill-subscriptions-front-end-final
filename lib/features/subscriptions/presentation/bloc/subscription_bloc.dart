import 'package:bill_subscription_notifier/features/auth/core/session/session_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'subscription_event.dart';
import 'subscription_state.dart';
import '../../domain/usecases/get_subscriptions.dart';
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetSubscriptions getSubscriptions;

  SubscriptionBloc(this.getSubscriptions)
      : super(SubscriptionInitial()) {
    on<LoadSubscriptions>(_onLoad);
    on<UnsubscribeSubscription>(_onUnsubscribe);
  }

  String get _token => SessionManager.getToken() ?? '';

  Future<void> _onLoad(
    LoadSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());

    try {
      final data = await getSubscriptions(_token);
      emit(SubscriptionLoaded(data));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> _onUnsubscribe(
    UnsubscribeSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    // call API here with _token + event.id
  }
}