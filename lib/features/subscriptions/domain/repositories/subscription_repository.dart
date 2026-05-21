import '../entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<List<SubscriptionEntity>> getSubscriptions(String token);
}