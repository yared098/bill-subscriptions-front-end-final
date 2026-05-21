import '../../domain/entities/subscription_entity.dart';

abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionEntity> subscriptions;

  SubscriptionLoaded(this.subscriptions);
}

class SubscriptionError extends SubscriptionState {
  final String message;

  SubscriptionError(this.message);
}