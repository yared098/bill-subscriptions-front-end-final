import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';

class AuthController {
  final AuthRepositoryImpl repo =
      AuthRepositoryImpl(AuthRemoteDataSource());

  UserEntity? user;
  String? token;

  // =========================
  // LOGIN
  // =========================
Future<bool> login(String email, String password) async {
  final res = await repo.login(
    email: email,
    password: password,
  );

  if (res["success"] == true) {
    token = res["token"];

    await _saveToken(token!);

    // 🔥 AUTO LOAD PROFILE AFTER LOGIN
    await loadUserProfile();

    return true;
  }

  return false;
}

  // =========================
  // REGISTER
  // =========================
 Future<bool> register({
  required String fullName,
  required String username,
  required String email,
  required String phone,
  required String faydaId,
  required String password,
}) async {
  final res = await repo.register(
    fullName: fullName,
    username: username,
    email: email,
    phone: phone,
    faydaId: faydaId,
    password: password,
  );

  return res["success"] == true;
}

  // =========================
  // 🔥 LOAD USER PROFILE (NEW)
  // =========================
  Future<UserEntity?> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return null;

    final res = await repo.getProfile(token);

    if (res["success"] == true) {
      user = UserEntity.fromJson(res["data"]);
      return user;
    }

    return null;
  }


  // =========================
  // SAVE TOKEN
  // =========================
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  // =========================
  // GET TOKEN
  // =========================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    user = null;
    token = null;
  }

  
}