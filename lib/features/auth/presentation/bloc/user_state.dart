import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

class UserState extends Equatable {
  final bool loading;
  final UserEntity? user;
  final String? error;
  final bool success;

  const UserState({
    this.loading = false,
    this.user,
    this.error,
    this.success = false,
  });

  UserState copyWith({
    bool? loading,
    UserEntity? user,
    String? error,
    bool? success,
  }) {
    return UserState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [loading, user, error, success];
}