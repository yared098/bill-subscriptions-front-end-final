abstract class BillEvent {}

class LoadBills extends BillEvent {}

class FilterBills extends BillEvent {
  final String type;

  FilterBills({required this.type});
}

class RefreshBills extends BillEvent {}

class ResetBills extends BillEvent {}