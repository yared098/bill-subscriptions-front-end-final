import '../entities/dashboard_entity.dart';
import '../entities/analytics_entity.dart';

abstract class OverviewRepository {
  Future<DashboardEntity> getDashboard(String token);
  Future<AnalyticsEntity> getAnalytics(String token);
}