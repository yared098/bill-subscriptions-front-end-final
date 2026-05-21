import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repo;

  GetNotifications(this.repo);

  Future<List<NotificationEntity>> call(String token) {
    return repo.getNotifications(token);
  }

  
}