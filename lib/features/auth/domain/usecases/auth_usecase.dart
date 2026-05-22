import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  // =========================
  // LOGIN
  // =========================

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) {
    return repository.login(
      email: email,
      password: password,
    );
  }

  // =========================
  // REGISTER (UPDATED)
  // =========================

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String faydaId,
    required String password,
  }) {
    return repository.register(
      fullName: fullName,
      username: username,
      email: email,
      phone: phone,
      faydaId: faydaId,
      password: password,
    );
  }

  // =========================
  // PROFILE
  // =========================

  Future<Map<String, dynamic>> getProfile(
    String token,
  ) {
    return repository.getProfile(token);
  }

  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String fullName,
    required String username,
    required String phone,
    String? profileImage,
  }) {
    return repository.updateProfile(
      token: token,
      fullName: fullName,
      username: username,
      phone: phone,
      profileImage: profileImage,
    );
  }

  // =========================
  // SECURITY
  // =========================

  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      token: token,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<Map<String, dynamic>> deleteAccount(
    String token,
  ) {
    return repository.deleteAccount(token);
  }
}