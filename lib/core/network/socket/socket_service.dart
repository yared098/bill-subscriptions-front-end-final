import 'package:bill_subscription_notifier/core/config/app_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;
  bool _isConnected = false;

  void connect(String userId) {
    _socket = IO.io(
      AppConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setReconnectionAttempts(10)
          .setReconnectionDelay(2000)
          .disableAutoConnect()
          .build(),
    );

    _socket.onConnect((_) {
      _isConnected = true;
      print('🟢 Socket Connected');

      _socket.emit('join', userId.toString());
    });

    _socket.onReconnect((_) {
      print("♻️ Reconnected");
      _socket.emit('join', userId.toString());
    });

    _socket.onDisconnect((_) {
      _isConnected = false;
      print('🔴 Socket Disconnected');
    });

    _socket.onConnectError((err) {
      print('❌ Connect error: $err');
    });

    _socket.connect();
  }

  void listenNotifications(Function(dynamic data) onData) {
    _socket.on('notification', (data) {
      print('🔔 Notification received: $data');
      onData(data);
    });
  }

  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      _socket.dispose();
    }
  }
}