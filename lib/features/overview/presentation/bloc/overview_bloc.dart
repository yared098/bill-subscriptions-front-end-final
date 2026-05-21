// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'overview_event.dart';
// import 'overview_state.dart';
// import '../../domain/usecases/get_overview.dart';

// class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
//   final GetOverview getOverview;

//   OverviewBloc(this.getOverview) : super(OverviewInitial()) {
//     on<LoadOverview>(_onLoad);
//   }

//   Future<void> _onLoad(
//     LoadOverview event,
//     Emitter<OverviewState> emit,
//   ) async {
//     emit(OverviewLoading());

//     try {
//       final result = await getOverview(event.token);

//       emit(
//         OverviewLoaded(
//           dashboard: result["dashboard"],
//           analytics: result["analytics"],
//         ),
//       );
//     } catch (e) {
//       emit(OverviewError(e.toString()));
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';

import 'overview_event.dart';
import 'overview_state.dart';
import '../../domain/usecases/get_overview.dart';

class OverviewBloc
    extends Bloc<OverviewEvent, OverviewState> {
  final GetOverview getOverview;

  OverviewBloc(this.getOverview)
      : super(OverviewInitial()) {
    // =========================
    // EVENTS
    // =========================
    on<LoadOverview>(_onLoad);
    on<RefreshOverview>(_onRefresh);
  }

  // =========================
  // LOAD OVERVIEW
  // =========================
  Future<void> _onLoad(
    LoadOverview event,
    Emitter<OverviewState> emit,
  ) async {
    emit(OverviewLoading());

    try {
      final result = await getOverview(
        event.token,
      );

      // =========================
      // API RESPONSE
      // =========================
      final dashboard =
          result["dashboard"];

      final analytics =
          result["analytics"];

      // =========================
      // SUCCESS
      // =========================
      emit(
        OverviewLoaded(
          dashboard: dashboard,
          analytics: analytics,
        ),
      );
    } catch (e) {
      emit(
        OverviewError(
          _handleError(e),
        ),
      );
    }
  }

  // =========================
  // REFRESH OVERVIEW
  // =========================
  Future<void> _onRefresh(
    RefreshOverview event,
    Emitter<OverviewState> emit,
  ) async {
    try {
      final result = await getOverview(
        event.token,
      );

      emit(
        OverviewLoaded(
          dashboard:
              result["dashboard"],
          analytics:
              result["analytics"],
        ),
      );
    } catch (e) {
      emit(
        OverviewError(
          _handleError(e),
        ),
      );
    }
  }

  // =========================
  // ERROR HANDLER
  // =========================
  String _handleError(dynamic error) {
    final message =
        error.toString().toLowerCase();

    if (message.contains("socket")) {
      return "No internet connection";
    }

    if (message.contains("timeout")) {
      return "Request timeout";
    }

    if (message.contains("401")) {
      return "Unauthorized access";
    }

    if (message.contains("500")) {
      return "Internal server error";
    }

    return "Something went wrong";
  }
}