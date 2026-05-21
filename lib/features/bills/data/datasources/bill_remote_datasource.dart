import 'dart:convert';
import 'package:bill_subscription_notifier/core/config/app_config.dart';
import 'package:http/http.dart' as http;

class BillRemoteDataSource {
  final String baseUrl = "${AppConfig.baseUrl}/bills";

  Future<List<dynamic>> getBills(String token, String? type) async {
    final uri = Uri.parse(
      type != null
          ? "$baseUrl/my-bills?type=$type"
          : "$baseUrl/my-bills",
    );

    final res = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(data["message"] ?? "Failed to load bills");
    }

    // backend returns: { success: true, data: [] }
    return data["data"];
  }
}