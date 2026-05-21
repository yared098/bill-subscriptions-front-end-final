import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/pages/financial_overview_page.dart';
import 'package:bill_subscription_notifier/features/notifications/presentation/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:bill_subscription_notifier/features/auth/core/session/session_manager.dart';
import 'package:bill_subscription_notifier/features/auth/presentation/pages/login_page.dart';
import 'package:bill_subscription_notifier/features/auth/presentation/pages/register_page.dart';
import 'package:bill_subscription_notifier/features/auth/presentation/pages/home_page.dart'; 

// Features
import 'package:bill_subscription_notifier/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:bill_subscription_notifier/features/overview/presentation/pages/overview_page.dart';
import 'package:bill_subscription_notifier/features/overview/presentation/bloc/overview_bloc.dart';
import 'package:bill_subscription_notifier/features/overview/domain/usecases/get_overview.dart';
import 'package:bill_subscription_notifier/features/overview/data/repositories/overview_repository_impl.dart';
import 'package:bill_subscription_notifier/features/overview/data/datasources/overview_remote_datasource.dart';

import 'package:bill_subscription_notifier/features/bills/presentation/pages/bill_page.dart';
import 'package:bill_subscription_notifier/features/bills/presentation/bloc/bill_bloc.dart';
import 'package:bill_subscription_notifier/features/bills/domain/usecases/get_bills.dart';
import 'package:bill_subscription_notifier/features/bills/data/repositories/bill_repository_impl.dart';
import 'package:bill_subscription_notifier/features/bills/data/datasources/bill_remote_datasource.dart';

import 'package:bill_subscription_notifier/features/subscriptions/presentation/pages/subscription_page.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_bloc.dart';
import 'package:bill_subscription_notifier/features/subscriptions/domain/usecases/get_subscriptions.dart';
import 'package:bill_subscription_notifier/features/subscriptions/data/repositories/subscription_repository_impl.dart';
import 'package:bill_subscription_notifier/features/subscriptions/data/datasources/subscription_remote_datasource.dart';

import 'package:bill_subscription_notifier/features/payments/presentation/pages/payment_page.dart';
import 'package:bill_subscription_notifier/features/payments/presentation/bloc/payment_bloc.dart';
import 'package:bill_subscription_notifier/features/payments/domain/usecases/create_payment.dart';
import 'package:bill_subscription_notifier/features/payments/data/repositories/payment_repository_impl.dart';
import 'package:bill_subscription_notifier/features/payments/data/datasources/payment_remote_datasource.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',

    redirect: (context, state) {
      // 1. Core State Verification
      final bool onboardingDone = SessionManager.isOnboardingCompleted();
      final String? token = SessionManager.getToken();

      // 2. Intercept uncompleted onboarding state
      if (!onboardingDone) {
        return '/onboarding';
      }

      // 3. Re-route away from onboarding if already completed
      if (state.matchedLocation == '/onboarding' && onboardingDone) {
        return token == null ? '/login' : '/dashboard';
      }

      // 4. Authenticated state pipeline checks
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (token == null && !isAuthRoute) {
        return '/login';
      }

      if (token != null && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },

    routes: [
      // =========================
      // ONBOARDING
      // =========================
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // =========================
      // AUTH
      // =========================
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // =========================
      // MAIN SHELL (NO HomeShell NEEDED)
      // =========================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            // bottomNavigationBar: BottomNavigationBar(
            //   type: BottomNavigationBarType.fixed,
            //   currentIndex: navigationShell.currentIndex,
            //   onTap: (index) {
            //     navigationShell.goBranch(index);
            //   },
            //   items: const [
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.dashboard),
            //       label: "Overview",
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.receipt_long),
            //       label: "Bills",
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.subscriptions),
            //       label: "Subscriptions",
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.payment),
            //       label: "Payments",
            //     ),
            //   ],
            // ),
         
         bottomNavigationBar: Container(
  decoration: const BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 24,
        offset: Offset(0, -2),
      ),
    ],
  ),
  child: SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: "Overview",
            isActive: navigationShell.currentIndex == 0,
            onTap: () => navigationShell.goBranch(0),
          ),
          _NavItem(
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
            label: "Bills",
            isActive: navigationShell.currentIndex == 1,
            onTap: () => navigationShell.goBranch(1),
          ),
          _NavItem(
            icon: Icons.subscriptions_outlined,
            activeIcon: Icons.subscriptions,
            label: "Subs",
            isActive: navigationShell.currentIndex == 2,
            onTap: () => navigationShell.goBranch(2),
          ),
          _NavItem(
            icon: Icons.payment_outlined,
            activeIcon: Icons.payment,
            label: "Pay",
            isActive: navigationShell.currentIndex == 3,
            onTap: () => navigationShell.goBranch(3),
          ),
        ],
      ),
    ),
  ),
),
         
          );
        },

        branches: [
          // =========================
          // 0. OVERVIEW (DEFAULT TAB)
          // =========================
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) {
                  return BlocProvider(
                    create: (_) => OverviewBloc(
                      GetOverview(
                        OverviewRepositoryImpl(
                          OverviewRemoteDataSource(),
                        ),
                      ),
                    ),
                    child: FinancialOverviewPage(),
                  );
                },
              ),
            ],
          ),

          // =========================
          // 1. BILLS
          // =========================
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bills',
                builder: (context, state) {
                  final token = SessionManager.getToken() ?? '';

                  return BlocProvider(
                    create: (_) => BillBloc(
                      GetBills(
                        BillRepositoryImpl(
                          BillRemoteDataSource(),
                        ),
                      ),
                    ),
                    child: BillPage(token: token),
                  );
                },
              ),
            ],
          ),

          // =========================
          // 2. SUBSCRIPTIONS
          // =========================
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/subscriptions',
                builder: (context, state) {
                  final token = SessionManager.getToken() ?? '';

                  return BlocProvider(
                    create: (_) => SubscriptionBloc(
                      GetSubscriptions(
                        SubscriptionRepositoryImpl(
                          SubscriptionRemoteDataSource(),
                        ),
                      ),
                    ),
                    child: SubscriptionPage(token: token),
                  );
                },
              ),
            ],
          ),

          // =========================
          // 3. PAYMENTS
          // =========================
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/payments',
                builder: (context, state) {
                  final token = SessionManager.getToken() ?? '';

                  return BlocProvider(
                    create: (_) => PaymentBloc(
                      CreatePayment(
                        PaymentRepositoryImpl(
                          PaymentRemoteDataSource(),
                        ),
                      ),
                    ),
                    child: PaymentPage(token: token),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
  
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF2563EB) : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}