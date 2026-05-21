abstract class SubscriptionEvent {}

class LoadSubscriptions extends SubscriptionEvent {}

class UnsubscribeSubscription extends SubscriptionEvent {
  final String id;
  final String reason;

  UnsubscribeSubscription({
    required this.id,
    required this.reason,
  });
}