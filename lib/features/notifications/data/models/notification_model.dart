import '../../domain/entities/notification_entity.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.isRead,
    required super.createdAt,
    this.type,
  });

  // optional type from backend (bill/subscription/system/organization)
  final String? type;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      message: json["message"] ?? "",

      // ✅ FIX: backend field is "read", NOT "isRead"
      isRead: json["read"] ?? false,

      createdAt: DateTime.parse(json["createdAt"]),

      // optional but useful for UI filtering
      type: json["type"],
    );
  }
}
enum NotificationType { bill, subscription }

class UnifiedNotificationItem {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String status;
  final NotificationType type;

  UnifiedNotificationItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.type,
  });
}