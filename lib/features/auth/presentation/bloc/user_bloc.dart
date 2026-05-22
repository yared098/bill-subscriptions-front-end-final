import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_event.dart';
import 'user_state.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthRepositoryImpl repo;
  final String token;

  UserBloc({
    required this.repo,
    required this.token,
  }) : super(const UserState()) {
    on<LoadUserProfile>(_onLoad);
    on<UpdateUserProfile>(_onUpdate);
    on<ChangeUserPassword>(_onChangePassword);
    on<DeleteUserAccount>(_onDelete);
  }

  // =========================
  // LOAD PROFILE
  // =========================
  Future<void> _onLoad(
    LoadUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final res = await repo.getProfile(token);

    if (res["success"] == true) {
      final user = UserEntity.fromJson(res["data"]);

      emit(state.copyWith(
        loading: false,
        user: user,
      ));
    } else {
      emit(state.copyWith(
        loading: false,
        error: res["message"],
      ));
    }
  }

  // =========================
  // UPDATE PROFILE
  // =========================
  Future<void> _onUpdate(
    UpdateUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final res = await repo.updateProfile(
      token: token,
      fullName: event.fullName,
      username: event.username,
      phone: event.phone,
      profileImage: event.profileImage,
    );

    if (res["success"] == true) {
      final user = UserEntity.fromJson(res["data"]);

      emit(state.copyWith(
        loading: false,
        user: user,
        success: true,
      ));
    } else {
      emit(state.copyWith(
        loading: false,
        error: res["message"],
      ));
    }
  }

  // =========================
  // CHANGE PASSWORD
  // =========================
  Future<void> _onChangePassword(
    ChangeUserPassword event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final res = await repo.changePassword(
      token: token,
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    if (res["success"] == true) {
      emit(state.copyWith(
        loading: false,
        success: true,
      ));
    } else {
      emit(state.copyWith(
        loading: false,
        error: res["message"],
      ));
    }
  }

  // =========================
  // DELETE ACCOUNT
  // =========================
  Future<void> _onDelete(
    DeleteUserAccount event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final res = await repo.deleteAccount(token);

    if (res["success"] == true) {
      emit(const UserState(
        loading: false,
        user: null,
        success: true,
      ));
    } else {
      emit(state.copyWith(
        loading: false,
        error: res["message"],
      ));
    }
  }
}