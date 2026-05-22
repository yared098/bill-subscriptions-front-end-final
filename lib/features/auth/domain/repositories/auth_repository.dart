import '../entities/user_entity.dart';

abstract class AuthRepository {
  // =========================
  // AUTH
  // =========================

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String faydaId,
    required String password,
  });

  // =========================
  // PROFILE
  // =========================

  Future<Map<String, dynamic>> getProfile(
    String token,
  );

  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String fullName,
    required String username,
    required String phone,
    String? profileImage,
  });

  // =========================
  // SECURITY
  // =========================

  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  });

  Future<Map<String, dynamic>> deleteAccount(
    String token,
  );
}