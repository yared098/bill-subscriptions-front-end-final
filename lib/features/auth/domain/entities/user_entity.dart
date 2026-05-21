class UserEntity {
  final String id;
  final String fullName;
  final String email;
  final String role;

  // OPTIONAL (based on your backend)
  final String? phone;
  final String? profileImage;
  final bool? emailVerified;

  UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.phone,
    this.profileImage,
    this.emailVerified,
  });

  // =========================
  // FROM JSON
  // =========================
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      phone: json['phone'],
      profileImage: json['profileImage'],
      emailVerified: json['emailVerified'],
    );
  }

  // =========================
  // TO JSON
  // =========================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'phone': phone,
      'profileImage': profileImage,
      'emailVerified': emailVerified,
    };
  }
}