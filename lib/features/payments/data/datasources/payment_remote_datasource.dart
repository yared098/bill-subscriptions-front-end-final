import 'dart:convert';
import 'package:bill_subscription_notifier/core/config/app_config.dart';
import 'package:http/http.dart' as http;

class PaymentRemoteDataSource {
 
  final String baseUrl = "${AppConfig.baseUrl}/payments";

  Future<Map<String, dynamic>> createPayment({
    required double amount,
    required String provider,
    required String purpose,
    required String token,
  }) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "amount": amount,
        "provider": provider,
        "purpose": purpose,
      }),
    );

    return jsonDecode(res.body);
  }
}