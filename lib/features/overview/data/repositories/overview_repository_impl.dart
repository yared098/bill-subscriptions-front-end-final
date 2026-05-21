import 'package:bill_subscription_notifier/features/bills/domain/entities/bill_entity.dart';

import 'package:bill_subscription_notifier/features/subscriptions/domain/entities/subscription_entity.dart';

import '../../domain/entities/dashboard_entity.dart';

import '../../domain/entities/analytics_entity.dart';

import '../../domain/repositories/overview_repository.dart';

import '../datasources/overview_remote_datasource.dart';

class OverviewRepositoryImpl
    implements OverviewRepository {
  final OverviewRemoteDataSource remote;

  OverviewRepositoryImpl(this.remote);

  // =========================
  // GET DASHBOARD
  // =========================
  @override
  Future<DashboardEntity> getDashboard(
    String token,
  ) async {
    final res = await remote.getDashboard(
      token,
    );

    final data = res["data"];

    // =========================
    // UPCOMING BILLS
    // =========================
   final upcomingBills = (data["upcomingBills"] as List? ?? [])
    .map(
      (bill) => BillEntity(
        id: bill["_id"] ?? "",
        title: bill["title"] ?? "",
        amount: (bill["amount"] ?? 0).toDouble(),
        status: bill["status"] ?? "unpaid",
        dueDate: DateTime.tryParse(
              bill["dueDate"] ?? "",
            ) ??
            DateTime.now(),
        category: bill["category"] ?? "Other",

        // ✅ NEW FIELDS (IMPORTANT)
        organizationName: bill["organizationName"] ?? "Unknown",
        notes: bill["notes"],
        recurring: bill["recurring"] ?? false,
      ),
    )
    .toList();

    // =========================
    // UPCOMING SUBSCRIPTIONS
    // =========================
    final upcomingSubscriptions =
        (data["upcomingSubscriptions"]
                    as List? ??
                [])
            .map(
              (sub) =>
                  SubscriptionEntity(
                id: sub["_id"] ?? "",

                name:
                    sub["serviceName"] ??
                        "",

                amount:
                    (sub["amount"] ?? 0)
                        .toDouble(),

                status:
                    sub["status"] ??
                        "active",

                startDate:
                    DateTime.parse(
                  sub["renewalDate"] ??
                      DateTime.now()
                          .toIso8601String(),
                ),
              ),
            )
            .toList();

    // =========================
    // RECENT BILLS
    // =========================
   final recentBills = (data["recentBills"] as List? ?? [])
    .map(
      (bill) => BillEntity(
        id: bill["_id"] ?? "",
        title: bill["title"] ?? "",
        amount: (bill["amount"] ?? 0).toDouble(),
        status: bill["status"] ?? "unpaid",
        dueDate: DateTime.tryParse(
              bill["dueDate"] ?? "",
            ) ??
            DateTime.now(),
        category: bill["category"] ?? "Other",

        // ✅ NEW FIELDS
        organizationName: bill["organizationName"] ?? "Unknown",
        notes: bill["notes"],
        recurring: bill["recurring"] ?? false,
      ),
    )
    .toList();

    // =========================
    // RECENT SUBSCRIPTIONS
    // =========================
    final recentSubscriptions =
        (data["recentSubscriptions"]
                    as List? ??
                [])
            .map(
              (sub) =>
                  SubscriptionEntity(
                id: sub["_id"] ?? "",

                name:
                    sub["serviceName"] ??
                        "",

                amount:
                    (sub["amount"] ?? 0)
                        .toDouble(),

                status:
                    sub["status"] ??
                        "active",

                startDate:
                    DateTime.parse(
                  sub["renewalDate"] ??
                      DateTime.now()
                          .toIso8601String(),
                ),
              ),
            )
            .toList();

    return DashboardEntity(
      totalMonthlyExpenses:
          (data["totalMonthlyExpenses"] ??
                  0)
              .toDouble(),

      totalBills:
          (data["totalBills"] ?? 0)
              .toDouble(),

      totalSubscriptions:
          (data["totalSubscriptions"] ??
                  0)
              .toDouble(),

      unpaidBillsCount:
          data["unpaidBillsCount"] ??
              0,

      upcomingBills:
          upcomingBills,

      upcomingSubscriptions:
          upcomingSubscriptions,

      recentBills:
          recentBills,

      recentSubscriptions:
          recentSubscriptions,
    );
  }

  // =========================
  // GET ANALYTICS
  // =========================
  @override
  Future<AnalyticsEntity>
      getAnalytics(
    String token,
  ) async {
    final res = await remote.getAnalytics(
      token,
    );

    final data = res["data"];

    return AnalyticsEntity(
      totalExpense:
          (data["totalExpense"] ?? 0)
              .toDouble(),

      categoryBreakdown:
          data["categoryBreakdown"] ??
              [],

      monthlySpending:
          data["monthlySpending"] ??
              [],

      topCategory:
          data["insights"]
              ?["topCategory"],

      highestMonth:
          data["insights"]
                  ?["highestMonth"] ??
              "Unknown",

      averageExpense:
          (data["insights"]
                      ?["averageExpense"] ??
                  0)
              .toDouble(),
    );
  }
}