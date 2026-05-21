import '../../domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  final String provider;
  final bool isSubscribed;

  SubscriptionModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.status,
    required super.startDate,
    required this.provider,
    required this.isSubscribed,
  });

  /// =========================
  /// SAFE JSON FACTORY
  /// =========================
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json["_id"]?.toString() ?? "",

      name: json["serviceName"]?.toString().isNotEmpty == true
          ? json["serviceName"]
          : "Unknown Service",

      provider: json["providerName"] ??
          json["provider"] ??
          "Unknown Provider",

      amount: (json["amount"] is num)
          ? (json["amount"] as num).toDouble()
          : double.tryParse(json["amount"].toString()) ?? 0.0,

      status: json["status"]?.toString() ?? "inactive",

      startDate: DateTime.tryParse(json["renewalDate"] ?? "") ??
          DateTime.tryParse(json["startDate"] ?? "") ??
          DateTime.now(),

      isSubscribed: json["isSubscribed"] ?? true,
    );
  }

  /// =========================
  /// UI HELPERS (VERY IMPORTANT)
  /// =========================

  bool get isActive => status.toLowerCase() == "active";

  String get displayStatus => isActive ? "Active" : "Inactive";

  String get formattedAmount => "ETB ${amount.toStringAsFixed(2)}";
}