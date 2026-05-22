import 'package:bill_subscription_notifier/core/network/socket/notificationservice.dart' show LocalNotificationService;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bill_subscription_notifier/features/auth/core/session/session_manager.dart';

import 'notification_event.dart';
import 'notification_state.dart';

import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import '../../domain/repositories/socket_repository.dart';
import '../../domain/entities/notification_entity.dart';

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

    // REST
    on<LoadNotifications>(_onLoad);
    on<MarkAsRead>(_onMarkAsRead);

    // SOCKET
    on<StartSocketEvent>(_onStartSocket);
    on<NewNotificationReceivedEvent>(_onNewSocketNotification);
    on<DisconnectSocketEvent>(_onDisconnect);
  }

  // =========================
  // LOAD NOTIFICATIONS
  // =========================
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

  // =========================
  // MARK AS READ
  // =========================
  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await markAsRead(_token, event.id);

      final data = await getNotifications(_token);
      emit(NotificationLoaded(data));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  // =========================
  // START SOCKET
  // =========================
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

  // =========================
  // SOCKET → ADD NEW NOTIFICATION
  // =========================
  // void _onNewSocketNotification(
  //   NewNotificationReceivedEvent event,
  //   Emitter<NotificationState> emit,
  // ) {
  //   final currentState = state;

  //   final newNotification =
  //       NotificationEntity.fromJson(event.data);

  //   if (currentState is NotificationLoaded) {
  //     final updated = [
  //       newNotification,
  //       ...currentState.notifications,
  //     ];

  //     emit(NotificationLoaded(updated));
  //   } else {
  //     // fallback if socket arrives before REST load
  //     emit(NotificationLoaded([newNotification]));
  //   }
  // }

void _onNewSocketNotification(
  NewNotificationReceivedEvent event,
  Emitter<NotificationState> emit,
) async {
  final newNotification =
      NotificationEntity.fromJson(event.data);

  // =========================
  // 🔔 SHOW LOCAL NOTIFICATION
  // =========================
  await LocalNotificationService.showNotification(
    title: newNotification.title,
    body: newNotification.message,
  );

  final currentState = state;

  if (currentState is NotificationLoaded) {
    emit(
      NotificationLoaded([
        newNotification,
        ...currentState.notifications,
      ]),
    );
  } else {
    emit(NotificationLoaded([newNotification]));
  }
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