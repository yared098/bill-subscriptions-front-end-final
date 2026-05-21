import '../entities/dashboard_entity.dart';
import '../entities/analytics_entity.dart';
import '../repositories/overview_repository.dart';

class GetOverview {
  final OverviewRepository repo;

  GetOverview(this.repo);

  Future<Map<String, dynamic>> call(String token) async {
    final dashboard = await repo.getDashboard(token);
    final analytics = await repo.getAnalytics(token);

    return {
      "dashboard": dashboard,
      "analytics": analytics,
    };
  }
}