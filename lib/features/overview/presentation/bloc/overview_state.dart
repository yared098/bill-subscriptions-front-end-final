// overview_state.dart

import '../../domain/entities/dashboard_entity.dart';
import '../../domain/entities/analytics_entity.dart';

abstract class OverviewState {}

/// =========================
/// INITIAL
/// =========================
class OverviewInitial extends OverviewState {}

/// =========================
/// LOADING
/// =========================
class OverviewLoading extends OverviewState {}

/// =========================
/// LOADED
/// =========================
class OverviewLoaded extends OverviewState {
  final DashboardEntity dashboard;
  final AnalyticsEntity analytics;

  OverviewLoaded({
    required this.dashboard,
    required this.analytics,
  });
}

/// =========================
/// ERROR
/// =========================
class OverviewError extends OverviewState {
  final String message;

  OverviewError(this.message);
}