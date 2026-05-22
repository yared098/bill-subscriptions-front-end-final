import 'package:bill_subscription_notifier/features/auth/core/session/session_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_event.dart';
import 'notification_state.dart';

import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import '../../domain/repositories/socket_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markAsRead;
  final SocketRepository socketRepository;

  String get _token => SessionManager.getToken() ?? '';

  NotificationBloc(
    this.getNotifications,
    this.markAsRead,
    this.socketRepository,
  ) : super(NotificationInitial()) {

    // =========================
    // API EVENTS
    // =========================
    on<LoadNotifications>(_onLoad);
    on<MarkAsRead>(_onMarkAsRead);

    // =========================
    // SOCKET EVENTS
    // =========================
    on<StartSocketEvent>(_onStartSocket);
    on<NewNotificationReceivedEvent>(_onNewSocketNotification);
    on<DisconnectSocketEvent>(_onDisconnect);
  }

  // ===================================
  // LOAD NOTIFICATIONS (REST)
  // ===================================
  Future<void> _onLoad(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final data = await getNotifications(_token);
      emit(NotificationLoaded(data));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  // ===================================
  // MARK AS READ (REST)
  // ===================================
  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await markAsRead(_token, event.id);

      final updated = await getNotifications(_token);
      emit(NotificationLoaded(updated));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  // ===================================
  // START SOCKET
  // ===================================
  void _onStartSocket(
    StartSocketEvent event,
    Emitter<NotificationState> emit,
  ) {
    socketRepository.connect(event.userId);

    socketRepository.listen((data) {
      add(NewNotificationReceivedEvent(data));
    });

    emit(SocketConnected());
  }

  // ===================================
  // RECEIVE SOCKET NOTIFICATION
  // ===================================
  void _onNewSocketNotification(
    NewNotificationReceivedEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationReceived(event.data));
  }

  // ===================================
  // DISCONNECT SOCKET
  // ===================================
  void _onDisconnect(
    DisconnectSocketEvent event,
    Emitter<NotificationState> emit,
  ) {
    socketRepository.disconnect();
    emit(NotificationInitial());
  }
}