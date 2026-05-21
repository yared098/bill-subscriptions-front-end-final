import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) {
    return repository.login(
      email: email,
      password: password,
    );
  }

  Future<Map<String, dynamic>> register(
    String fullName,
    String email,
    String password,
    String role,
  ) {
    return repository.register(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );
  }
}