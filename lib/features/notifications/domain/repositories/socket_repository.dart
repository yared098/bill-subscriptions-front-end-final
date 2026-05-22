abstract class SocketRepository {
  void connect(String userId);

  void listen(Function(dynamic data) onData);

  void disconnect();
}