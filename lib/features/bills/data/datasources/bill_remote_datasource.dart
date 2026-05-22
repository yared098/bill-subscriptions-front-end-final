import 'dart:convert';

import 'package:bill_subscription_notifier/core/config/app_config.dart';
import 'package:http/http.dart' as http;

class BillRemoteDataSource {
  final String baseUrl = "${AppConfig.baseUrl}/bills";

  // =========================================
  // GET USER BILLS
  // =========================================
  Future<List<dynamic>> getBills(
    String token,
    String? type,
  ) async {

    // ✅ UPDATED ROUTE
    final uri = Uri.parse(
      type != null
          ? "$baseUrl/me?type=$type"
          : "$baseUrl/me",
    );

    final res = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(res.body);

    // =========================================
    // ERROR HANDLING
    // =========================================
    if (res.statusCode != 200) {
      throw Exception(
        data["message"] ?? "Failed to load bills",
      );
    }

    // =========================================
    // SAFE RETURN
    // =========================================
    if (data["data"] == null) {
      return [];
    }

    return List<dynamic>.from(data["data"]);
  }
}