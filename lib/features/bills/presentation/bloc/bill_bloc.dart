import 'package:bill_subscription_notifier/features/auth/core/session/session_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bill_event.dart';
import 'bill_state.dart';
import '../../domain/usecases/get_bills.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  final GetBills getBills;

  BillBloc(this.getBills) : super(BillInitial()) {
    on<LoadBills>(_onLoadBills);
    on<FilterBills>(_onFilterBills);
    on<RefreshBills>(_onRefreshBills);
  }

  String get _token => SessionManager.getToken() ?? '';

  Future<void> _onLoadBills(
    LoadBills event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());

    try {
      final bills = await getBills(_token);
      emit(BillLoaded(bills));
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }

  Future<void> _onFilterBills(
    FilterBills event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());

    try {
      final bills = await getBills(_token, type: event.type);
      emit(BillLoaded(bills));
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }

  Future<void> _onRefreshBills(
    RefreshBills event,
    Emitter<BillState> emit,
  ) async {
    try {
      final bills = await getBills(_token);
      emit(BillLoaded(bills));
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }
}