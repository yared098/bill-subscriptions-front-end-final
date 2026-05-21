class SubscriptionEntity {
  final String id;
  final String name;
  final double amount;
  final String status;
  final DateTime startDate;

  SubscriptionEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.startDate,
  });
}