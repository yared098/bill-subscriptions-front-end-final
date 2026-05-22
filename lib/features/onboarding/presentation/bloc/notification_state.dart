abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class SocketConnected extends NotificationState {}

class NotificationReceived extends NotificationState {
  final dynamic data;

  NotificationReceived(this.data);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}