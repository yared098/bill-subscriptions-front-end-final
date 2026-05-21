import '../../domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  SubscriptionModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.status,
    required super.startDate,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json["_id"] ?? "",
      name: json["serviceName"] ?? "", // 🔥 FIXED
      amount: (json["amount"] ?? 0).toDouble(),
      status: json["status"] ?? "active",

      // 🔥 backend uses renewalDate (NOT startDate)
      startDate: DateTime.tryParse(
            json["renewalDate"] ?? "",
          ) ??
          DateTime.now(),
    );
  }
}