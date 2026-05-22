class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  // =========================
  // FROM JSON (FIXED FOR SOCKET + API)
  // =========================
  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      
      // backend may NOT send isRead in socket
      isRead: json['isRead'] ?? false,

      // socket might send string OR DateTime
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }

  // optional (useful for caching / local storage)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}