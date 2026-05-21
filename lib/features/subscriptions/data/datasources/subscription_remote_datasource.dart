import 'dart:convert';
import 'package:bill_subscription_notifier/core/config/app_config.dart';
import 'package:http/http.dart' as http;

class SubscriptionRemoteDataSource {
  final String baseUrl = "${AppConfig.baseUrl}/subscriptions";

  // =========================
  // GET USER SUBSCRIPTIONS
  // =========================
  Future<List> getSubscriptions(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/my"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(data["message"] ?? "Failed to load subscriptions");
    }

    return data["data"]; // 🔥 FIXED
  }

  Future<void> unsubscribe(
    String token,
    String id,
    String reason,
  ) async {
    final res = await http.patch(
      Uri.parse("$baseUrl/$id/unsubscribe"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "reason": reason,
      }),
    );

    if (res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data["message"] ?? "Failed to unsubscribe");
    }
  }
}