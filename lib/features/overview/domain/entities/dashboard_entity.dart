// class DashboardEntity {
//   final double totalMonthlyExpenses;
//   final double totalBills;
//   final double totalSubscriptions;
//   final int unpaidBillsCount;

//   DashboardEntity({
//     required this.totalMonthlyExpenses,
//     required this.totalBills,
//     required this.totalSubscriptions,
//     required this.unpaidBillsCount,
//   });
// }  

// dashboard_entity.dart

import 'package:bill_subscription_notifier/features/bills/domain/entities/bill_entity.dart';
import 'package:bill_subscription_notifier/features/subscriptions/domain/entities/subscription_entity.dart';


class DashboardEntity {
  final double totalMonthlyExpenses;

  final double totalBills;

  final double totalSubscriptions;

  final int unpaidBillsCount;

  // =========================
  // NEW FIELDS
  // =========================
  final List<BillEntity> upcomingBills;

  final List<SubscriptionEntity>
      upcomingSubscriptions;

  final List<BillEntity> recentBills;

  final List<SubscriptionEntity>
      recentSubscriptions;

  DashboardEntity({
    required this.totalMonthlyExpenses,
    required this.totalBills,
    required this.totalSubscriptions,
    required this.unpaidBillsCount,

    // NEW
    required this.upcomingBills,
    required this.upcomingSubscriptions,
    required this.recentBills,
    required this.recentSubscriptions,
  });
}