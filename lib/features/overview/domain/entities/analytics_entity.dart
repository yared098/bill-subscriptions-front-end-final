// class AnalyticsEntity {
//   final double totalExpense;
//   final List categoryBreakdown;
//   final List monthlySpending;
//   final String? topCategory;

//   AnalyticsEntity({
//     required this.totalExpense,
//     required this.categoryBreakdown,
//     required this.monthlySpending,
//     this.topCategory,
//   });
// }  
// analytics_entity.dart

class AnalyticsEntity {
  final double totalExpense;

  final List categoryBreakdown;

  final List monthlySpending;

  final String? topCategory;

  // =========================
  // NEW FIELDS
  // =========================
  final String highestMonth;

  final double averageExpense;

  AnalyticsEntity({
    required this.totalExpense,
    required this.categoryBreakdown,
    required this.monthlySpending,
    this.topCategory,

    // NEW
    required this.highestMonth,
    required this.averageExpense,
  });
}