import '../../domain/entities/notification_entity.dart';

abstract class NotificationEvent {}

// =========================
// REST EVENTS
// =========================
class LoadNotifications extends NotificationEvent {}

class MarkAsRead extends NotificationEvent {
  final String id;
  MarkAsRead(this.id);
}

// =========================
// SOCKET EVENTS
// =========================
class StartSocketEvent extends NotificationEvent {
  final String userId;
  StartSocketEvent(this.userId);
}

class NewNotificationReceivedEvent extends NotificationEvent {
  final dynamic data;
  NewNotificationReceivedEvent(this.data);
}

class DisconnectSocketEvent extends NotificationEvent {}