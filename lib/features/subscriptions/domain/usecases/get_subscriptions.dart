import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class GetSubscriptions {
  final SubscriptionRepository repo;

  GetSubscriptions(this.repo);

  Future<List<SubscriptionEntity>> call(String token) {
    return repo.getSubscriptions(token);
  }
}