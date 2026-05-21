import '../../domain/entities/bill_entity.dart';

abstract class BillState {}

// 🔥 initial
class BillInitial extends BillState {}

// 🔥 loading
class BillLoading extends BillState {}

// 🔥 loaded
class BillLoaded extends BillState {
  final List<BillEntity> bills;

  BillLoaded(this.bills);
}

// 🔥 error
class BillError extends BillState {
  final String message;

  BillError(this.message);
}