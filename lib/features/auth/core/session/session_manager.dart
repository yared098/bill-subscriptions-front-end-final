import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_entity.dart';

class SessionManager {
  static SharedPreferences? _prefs;

  static const String _userKey = "user";
  static const String _tokenKey = "token";
  static const String _onboardingKey = "is_onboarding_completed";

  // =========================
  // INIT
  // =========================
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // =========================
  // SAVE USER
  // =========================
  static Future<void> saveUser(UserEntity user) async {
    await _prefs!.setString(_userKey, jsonEncode(user.toJson()));
  }

  // =========================
  // GET USER
  // =========================
  static Future<UserEntity?> getUser() async {
    final data = _prefs!.getString(_userKey);

    if (data == null) return null;

    return UserEntity.fromJson(jsonDecode(data));
  }

  // =========================
  // SAVE TOKEN (JWT)
  // =========================
  static Future<void> saveToken(String token) async {
    await _prefs!.setString(_tokenKey, token);
  }

  static String? getToken() {
    return _prefs?.getString(_tokenKey);
  }

  // =========================
  // ONBOARDING STATE
  // =========================
  static bool isOnboardingCompleted() {
    return _prefs?.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingCompleted() async {
    await _prefs?.setBool(_onboardingKey, true);
  }

  // =========================
  // LOGOUT
  // =========================
  static Future<void> logout() async {
    await _prefs!.remove(_userKey);
    await _prefs!.remove(_tokenKey);
    // Note: We don't remove _onboardingKey here so users don't see onboarding again when they log out.
  }
}