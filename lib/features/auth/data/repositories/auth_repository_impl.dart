import 'package:bill_subscription_notifier/features/auth/domain/repositories/auth_repository.dart';

import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl
    implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  // =========================
  // LOGIN
  // =========================

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await remote.login(
      email,
      password,
    );
  }

  // =========================
  // REGISTER
  // =========================

  @override
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String faydaId,
    required String password,
  }) async {
    return await remote.register(
      fullName: fullName,
      username: username,
      email: email,
      phone: phone,
      faydaId: faydaId,
      password: password,
    );
  }

  // =========================
  // GET PROFILE
  // =========================

  @override
  Future<Map<String, dynamic>>
      getProfile(
    String token,
  ) async {
    return await remote.getProfile(
      token,
    );
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  @override
  Future<Map<String, dynamic>>
      updateProfile({
    required String token,
    required String fullName,
    required String username,
    required String phone,
    String? profileImage,
  }) async {
    return await remote.updateProfile(
      token: token,
      fullName: fullName,
      username: username,
      phone: phone,
      profileImage: profileImage,
    );
  }

  // =========================
  // CHANGE PASSWORD
  // =========================

  @override
  Future<Map<String, dynamic>>
      changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    return await remote.changePassword(
      token: token,
      currentPassword:
          currentPassword,
      newPassword: newPassword,
    );
  }

  // =========================
  // DELETE ACCOUNT
  // =========================

  @override
  Future<Map<String, dynamic>>
      deleteAccount(
    String token,
  ) async {
    return await remote.deleteAccount(
      token,
    );
  }
}