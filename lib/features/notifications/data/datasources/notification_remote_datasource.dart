import 'dart:convert';

import 'package:bill_subscription_notifier/core/config/app_config.dart';
import 'package:http/http.dart' as http;

class NotificationRemoteDataSource {
  final String baseUrl = "${AppConfig.baseUrl}/notifications";

  Future<List> getNotifications(String token) async {
    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(data["message"] ?? "Failed to load notifications");
    }

    // ✅ FIX: extract data
    return data["data"];
  }

  Future<void> markAsRead(String token, String id) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id/read"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      final data = jsonDecode(res.body);
      throw Exception(data["message"] ?? "Failed to mark as read");
    }
  }
}