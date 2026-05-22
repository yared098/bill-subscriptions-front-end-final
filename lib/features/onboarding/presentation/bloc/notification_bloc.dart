import 'package:bill_subscription_notifier/features/notifications/domain/repositories/socket_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_event.dart';
import 'notification_state.dart';


class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  final SocketRepository socketRepository;

  NotificationBloc(this.socketRepository)
      : super(NotificationInitial()) {
    
    on<StartSocketEvent>(_onStartSocket);
    on<NewNotificationReceivedEvent>(_onNewNotification);
    on<DisconnectSocketEvent>(_onDisconnect);
  }

  // =========================
  // START SOCKET
  // =========================
  void _onStartSocket(
      StartSocketEvent event,
      Emitter<NotificationState> emit,
  ) {
    emit(NotificationLoading());

    socketRepository.connect(event.userId);

    socketRepository.listen((data) {
      add(NewNotificationReceivedEvent(data));
    });

    emit(SocketConnected());
  }

  // =========================
  // RECEIVE NOTIFICATION
  // =========================
  void _onNewNotification(
      NewNotificationReceivedEvent event,
      Emitter<NotificationState> emit,
  ) {
    emit(NotificationReceived(event.data));
  }

  // =========================
  // DISCONNECT
  // =========================
  void _onDisconnect(
      DisconnectSocketEvent event,
      Emitter<NotificationState> emit,
  ) {
    socketRepository.disconnect();
    emit(NotificationInitial());
  }
}