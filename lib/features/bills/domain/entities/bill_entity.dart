class BillEntity {
  final String id;
  final String title;
  final double amount;
  final String status;
  final DateTime dueDate;
  final String category;

  // NEW (IMPORTANT FOR YOUR SYSTEM)
  final String organizationName;
  final String? notes;
  final bool recurring;

  BillEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.status,
    required this.dueDate,
    required this.category,
    required this.organizationName,
    this.notes,
    required this.recurring,
  });
}