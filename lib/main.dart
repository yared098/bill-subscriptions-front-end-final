import 'package:bill_subscription_notifier/core/network/socket/notificationservice.dart';
import 'package:bill_subscription_notifier/core/network/socket/socket_service.dart';
import 'package:bill_subscription_notifier/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:bill_subscription_notifier/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:bill_subscription_notifier/features/notifications/data/repositories/socket_repository_impl.dart';
import 'package:bill_subscription_notifier/features/notifications/domain/usecases/get_notifications.dart';
import 'package:bill_subscription_notifier/features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'package:bill_subscription_notifier/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bill_subscription_notifier/core/router/app_router.dart';
import 'package:bill_subscription_notifier/features/auth/core/session/session_manager.dart';
import 'package:provider/provider.dart';

/* =========================
   OVERVIEW
========================= */
import 'features/overview/presentation/bloc/overview_bloc.dart';
import 'features/overview/domain/usecases/get_overview.dart';
import 'features/overview/data/repositories/overview_repository_impl.dart';
import 'features/overview/data/datasources/overview_remote_datasource.dart';

/* =========================
   BILLS
========================= */
import 'features/bills/presentation/bloc/bill_bloc.dart';
import 'features/bills/domain/usecases/get_bills.dart';
import 'features/bills/data/repositories/bill_repository_impl.dart';
import 'features/bills/data/datasources/bill_remote_datasource.dart';

/* =========================
   SUBSCRIPTIONS
========================= */
import 'features/subscriptions/presentation/bloc/subscription_bloc.dart';
import 'features/subscriptions/domain/usecases/get_subscriptions.dart';
import 'features/subscriptions/data/repositories/subscription_repository_impl.dart';
import 'features/subscriptions/data/datasources/subscription_remote_datasource.dart';

/* =========================
   PAYMENTS
========================= */
import 'features/payments/presentation/bloc/payment_bloc.dart';
import 'features/payments/domain/usecases/create_payment.dart';
import 'features/payments/data/repositories/payment_repository_impl.dart';
import 'features/payments/data/datasources/payment_remote_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await LocalNotificationService.init(); // 🔥 ADD THIS

  await requestNotificationPermission(); // 🔥 ADD THIS
  await SessionManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     
   return MultiBlocProvider(
  providers: [
    // =========================
    // SOCKET SERVICE (ADD THIS)
    // =========================
    Provider<SocketService>(
      create: (_) => SocketService(),
      dispose: (_, socket) => socket.disconnect(),
    ),

    // =========================
    // OVERVIEW BLOC
    // =========================
    BlocProvider(
      create: (_) => OverviewBloc(
        GetOverview(
          OverviewRepositoryImpl(
            OverviewRemoteDataSource(),
          ),
        ),
      ),
    ),

    // =========================
    // BILLS BLOC
    // =========================
    BlocProvider(
      create: (_) => BillBloc(
        GetBills(
          BillRepositoryImpl(
            BillRemoteDataSource(),
          ),
        ),
      ),
    ),

    // =========================
    // SUBSCRIPTIONS BLOC
    // =========================
    BlocProvider(
      create: (_) => SubscriptionBloc(
        GetSubscriptions(
          SubscriptionRepositoryImpl(
            SubscriptionRemoteDataSource(),
          ),
        ),
      ),
    ),

    // =========================
    // NOTIFICATIONS BLOC
    // =========================
    BlocProvider(
      create: (context) {
        final remote = NotificationRemoteDataSource();
        final repo = NotificationRepositoryImpl(remote);

        final socketService = SocketRepositoryImpl(
          context.read<SocketService>(),
        );

        return NotificationBloc(
          GetNotifications(repo),
          MarkNotificationAsRead(repo),
          socketService,
        );
      },
    ),

    // =========================
    // PAYMENTS BLOC
    // =========================
    BlocProvider(
      create: (_) => PaymentBloc(
        CreatePayment(
          PaymentRepositoryImpl(
            PaymentRemoteDataSource(),
          ),
        ),
      ),
    ),
  ],
  child: MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: AppRouter.router,
  ),
);
  }

}