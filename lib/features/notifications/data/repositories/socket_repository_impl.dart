import 'package:bill_subscription_notifier/core/network/socket/socket_service.dart';
import 'package:bill_subscription_notifier/features/notifications/domain/repositories/socket_repository.dart';

class SocketRepositoryImpl implements SocketRepository {
  final SocketService socketService;

  SocketRepositoryImpl(this.socketService);

  @override
  void connect(String userId) {
    socketService.connect(userId);
  }

  @override
  void listen(Function(dynamic data) onData) {
    socketService.listenNotifications(onData); // ✅ FIXED
  }

  @override
  void disconnect() {
    socketService.disconnect();
  }
}