class UserEntity {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String role;

  final String? phone;
  final String? profileImage;
  final String? faydaId;
  final bool? isFaydaVerified;

  UserEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.role,
    this.phone,
    this.profileImage,
    this.faydaId,
    this.isFaydaVerified,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      phone: json['phone'],
      profileImage: json['profileImage'],
      faydaId: json['faydaId'],
      isFaydaVerified: json['isFaydaVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'role': role,
      'phone': phone,
      'profileImage': profileImage,
      'faydaId': faydaId,
      'isFaydaVerified': isFaydaVerified,
    };
  }
}