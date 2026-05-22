import 'package:bill_subscription_notifier/core/config/app_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketService {
  late IO.Socket _socket;
  bool _isConnected = false;

  // =========================
  // CONNECT SOCKET
  // =========================
  void connect(String userId) {
    _socket = IO.io(
      AppConfig.socketUrl, // ✅ FROM CONFIG
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      _isConnected = true;
      print('🟢 Socket Connected');

      // join user room
      _socket.emit('join', userId);
    });

    _socket.onDisconnect((_) {
      _isConnected = false;
      print('🔴 Socket Disconnected');
    });
  }

  // =========================
  // LISTEN NOTIFICATIONS
  // =========================
  void listenNotifications(Function(dynamic data) onData) {
    _socket.on('notification', (data) {
      print('🔔 Notification received: $data');
      onData(data);
    });
  }

  // =========================
  // DISCONNECT
  // =========================
  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      _socket.dispose();
    }
  }
}