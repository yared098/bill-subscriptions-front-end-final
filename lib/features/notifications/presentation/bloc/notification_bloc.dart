import 'package:bill_subscription_notifier/features/auth/core/session/session_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_event.dart';
import 'notification_state.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markAsRead;

  String get _token => SessionManager.getToken() ?? '';

  NotificationBloc(
    this.getNotifications,
    this.markAsRead,
  ) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoad);
    on<MarkAsRead>(_onMarkAsRead);
  }

  Future<void> _onLoad(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final data = await getNotifications(_token); // 🔥 HERE
      emit(NotificationLoaded(data));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await markAsRead(_token, event.id); // 🔥 HERE

      final updated = await getNotifications(_token);

      emit(NotificationLoaded(updated));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}