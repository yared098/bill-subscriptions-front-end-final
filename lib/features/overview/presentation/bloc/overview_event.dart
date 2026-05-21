// overview_event.dart

abstract class OverviewEvent {}

/// =========================
/// LOAD DASHBOARD
/// =========================
class LoadOverview extends OverviewEvent {
  final String token;

  LoadOverview(this.token);
}

/// =========================
/// REFRESH DASHBOARD
/// =========================
class RefreshOverview extends OverviewEvent {
  final String token;

  RefreshOverview(this.token);
}