import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// =========================
// LOAD PROFILE
// =========================
class LoadUserProfile extends UserEvent {}

// =========================
// UPDATE PROFILE
// =========================
class UpdateUserProfile extends UserEvent {
  final String fullName;
  final String username;
  final String phone;
  final String? profileImage;

  UpdateUserProfile({
    required this.fullName,
    required this.username,
    required this.phone,
    this.profileImage,
  });

  @override
  List<Object?> get props => [fullName, username, phone, profileImage];
}

// =========================
// CHANGE PASSWORD
// =========================
class ChangeUserPassword extends UserEvent {
  final String currentPassword;
  final String newPassword;

  ChangeUserPassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

// =========================
// DELETE ACCOUNT
// =========================
class DeleteUserAccount extends UserEvent {}