import '../../../../core/network/socket/socket_service.dart';

class SocketDataSource {
  final SocketService socketService;

  SocketDataSource(this.socketService);

  void connect(String userId) {
    socketService.connect(userId);
  }

  void listen(Function(dynamic data) onData) {
    socketService.listenNotifications(onData);
  }

  void disconnect() {
    socketService.disconnect();
  }
}