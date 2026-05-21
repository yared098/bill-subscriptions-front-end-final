import 'package:bill_subscription_notifier/features/auth/domain/repositories/auth_repository.dart';

import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await remote.login(email, password);
  }

  @override
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    return await remote.register(
      fullName,
      email,
      password,
      role,
    );
  }
  @override
Future<Map<String, dynamic>> getProfile(String token) async {
  return await remote.getProfile(token);
}
  
}