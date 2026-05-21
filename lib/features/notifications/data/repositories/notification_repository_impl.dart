import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl(this.remote);

  @override
  Future<List<NotificationEntity>> getNotifications(String token) async {
    final res = await remote.getNotifications(token);

    return res.map<NotificationEntity>((json) {
      return NotificationModel.fromJson(json);
    }).toList();
  }

  @override
  Future<void> markAsRead(String token, String id) {
    return remote.markAsRead(token, id);
  }
}