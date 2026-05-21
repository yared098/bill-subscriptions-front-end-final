import 'dart:convert';
import 'package:bill_subscription_notifier/core/config/app_config.dart';
import 'package:http/http.dart' as http;

class OverviewRemoteDataSource {
 
   final String baseUrl = "${AppConfig.baseUrl}";

  Future<Map<String, dynamic>> getDashboard(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/dashboard"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> getAnalytics(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/analytics"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(res.body);
  }
}