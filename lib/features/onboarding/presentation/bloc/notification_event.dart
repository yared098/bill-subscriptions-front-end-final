abstract class NotificationEvent {}

class StartSocketEvent extends NotificationEvent {
  final String userId;

  StartSocketEvent(this.userId);
}

class NewNotificationReceivedEvent extends NotificationEvent {
  final dynamic data;

  NewNotificationReceivedEvent(this.data);
}

class DisconnectSocketEvent extends NotificationEvent {}