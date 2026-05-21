import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_datasource.dart';
import '../models/subscription_model.dart';

class SubscriptionRepositoryImpl
    implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remote;

  SubscriptionRepositoryImpl(this.remote);

  @override
  Future<List<SubscriptionEntity>> getSubscriptions(
      String token) async {
    final res = await remote.getSubscriptions(token);

    return res.map<SubscriptionEntity>((json) {
      return SubscriptionModel.fromJson(json);
    }).toList();
  }
}