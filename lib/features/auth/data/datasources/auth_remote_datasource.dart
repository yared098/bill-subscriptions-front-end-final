import 'dart:convert';

import 'package:bill_subscription_notifier/core/config/app_config.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl =
      "${AppConfig.baseUrl}/users";

  // =========================
  // LOGIN
  // =========================

  Future<Map<String, dynamic>>
      login(
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),

      headers: {
        "Content-Type":
            "application/json",
      },

      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(res.body);
  }

  // =========================
  // REGISTER
  // =========================

  Future<Map<String, dynamic>>
      register({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String faydaId,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse(
        "$baseUrl/register",
      ),

      headers: {
        "Content-Type":
            "application/json",
      },

      body: jsonEncode({
        "fullName": fullName,
        "username": username,
        "email": email,
        "phone": phone,
        "faydaId": faydaId,
        "password": password,
      }),
    );

    return jsonDecode(res.body);
  }

  // =========================
  // GET PROFILE
  // =========================

  Future<Map<String, dynamic>>
      getProfile(
    String token,
  ) async {
    final res = await http.get(
      Uri.parse("$baseUrl/me"),

      headers: {
        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",
      },
    );

    return jsonDecode(res.body);
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  Future<Map<String, dynamic>>
      updateProfile({
    required String token,
    required String fullName,
    required String username,
    required String phone,
    String? profileImage,
  }) async {
    final res = await http.put(
      Uri.parse(
        "$baseUrl/update-profile",
      ),

      headers: {
        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",
      },

      body: jsonEncode({
        "fullName": fullName,
        "username": username,
        "phone": phone,
        "profileImage":
            profileImage,
      }),
    );

    return jsonDecode(res.body);
  }

  // =========================
  // CHANGE PASSWORD
  // =========================

  Future<Map<String, dynamic>>
      changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    final res = await http.put(
      Uri.parse(
        "$baseUrl/change-password",
      ),

      headers: {
        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",
      },

      body: jsonEncode({
        "currentPassword":
            currentPassword,

        "newPassword":
            newPassword,
      }),
    );

    return jsonDecode(res.body);
  }

  // =========================
  // DELETE ACCOUNT
  // =========================

  Future<Map<String, dynamic>>
      deleteAccount(
    String token,
  ) async {
    final res =
        await http.delete(
      Uri.parse(
        "$baseUrl/delete-account",
      ),

      headers: {
        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",
      },
    );

    return jsonDecode(res.body);
  }
}