import '../repositories/notification_repository.dart';

class MarkNotificationAsRead {
  final NotificationRepository repo;

  MarkNotificationAsRead(this.repo);

  Future<void> call(
    String token,
    String notificationId,
  ) {
    return repo.markAsRead(
      token,
      notificationId,
    );
  }
}