import '../../domain/entities/bill_entity.dart';

class BillModel extends BillEntity {
  BillModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.status,
    required super.dueDate,
    required super.category,
    required super.organizationName,
    super.notes,
    required super.recurring,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json["_id"],
      title: json["title"],
      amount: (json["amount"] as num).toDouble(),
      status: json["status"],
      dueDate: DateTime.parse(json["dueDate"]),
      category: json["category"] ?? "Other",

      // NEW FIELDS FROM BACKEND
      organizationName: json["organizationName"] ?? "Unknown",
      notes: json["notes"],
      recurring: json["recurring"] ?? false,
    );
  }
}