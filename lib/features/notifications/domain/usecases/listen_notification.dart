import '../repositories/socket_repository.dart';

class ListenNotificationUseCase {
  final SocketRepository repository;

  ListenNotificationUseCase(this.repository);

  void call(Function(dynamic data) onData) {
    repository.listen(onData);
  }
}