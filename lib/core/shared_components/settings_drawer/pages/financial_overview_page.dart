import 'dart:convert';

import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/pages/ExpenseMonthlyAnalysisPage.dart';
import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/pages/UtilitiesManagementPage.dart';
import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/LeftNavigationSidebar.dart';
import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/dashboard_list_item.dart';
import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/dashboard_section_list.dart';
import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/financial_items_list_page.dart';
import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/metric_summary_card.dart';
import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/notificationlists.dart';
import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/total_expense_card.dart';
import 'package:bill_subscription_notifier/features/auth/core/session/session_manager.dart';
import 'package:bill_subscription_notifier/features/auth/domain/entities/user_entity.dart';
import 'package:bill_subscription_notifier/features/bills/data/models/bill_model.dart';
import 'package:bill_subscription_notifier/features/bills/presentation/bloc/bill_bloc.dart';
import 'package:bill_subscription_notifier/features/bills/presentation/bloc/bill_event.dart';
import 'package:bill_subscription_notifier/features/bills/presentation/bloc/bill_state.dart';
import 'package:bill_subscription_notifier/features/subscriptions/data/models/subscription_model.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_bloc.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_event.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/settings_drawer_panel.dart';

import '../widgets/settings_drawer_panel.dart';

class FinancialOverviewPage extends StatefulWidget {
  const FinancialOverviewPage({super.key});

  @override
  State<FinancialOverviewPage> createState() => _FinancialOverviewPageState();
}

class _FinancialOverviewPageState extends State<FinancialOverviewPage> {
  bool _isSettingsOpen = true;
  String _currentSelectedRoute = 'Overview'; // Track left nav selection

  List<BillModel> bills = [];
  List<SubscriptionModel> subscriptions = [];
  UserEntity? currentUser;

  // Centralized method to load or refresh data
  Future<void> _loadData() async {
    context.read<BillBloc>().add(LoadBills());
    context.read<SubscriptionBloc>().add(LoadSubscriptions());

    // Optional: If you want the loading spinner to persist slightly for smooth UX,
    // you can await a small delay or await state changes from your Blocs.
    await Future.delayed(const Duration(milliseconds: 500));
  }
  // session_manager.dart
static Future<UserEntity?> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString("user");

  if (data == null) return null;

  return UserEntity.fromJson(jsonDecode(data));
}

  @override
  void initState() {
    super.initState();
    _loadData();
    _init();
  }
  Future<void> _init() async {
  await _loadData();

  final user = await SessionManager.getUser();

  if (mounted) {
    setState(() {
      currentUser = user;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;
        final isTablet =
            constraints.maxWidth >= 750 && constraints.maxWidth < 1140;

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: AppBar(
              backgroundColor: const Color(0xFFF9FAFB),
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Mobile menu button
                    if (isMobile)
                      Builder(
                        builder: (innerContext) => IconButton(
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Color(0xFF1E1E24),
                          ),
                          onPressed: () {
                            Scaffold.of(innerContext).openDrawer();
                          },
                        ),
                      ),
                    if (isMobile) const SizedBox(width: 8),

                    // TEXT SECTION (your converted header)
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E24),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Track your bills & subscriptions',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // RIGHT ACTIONS
                    Row(
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none_rounded,
                                color: Color(0xFF4B5563),
                              ),
                              onPressed: () => openNotificationsPanel(
                                context,
                                bills: bills,
                                subscriptions: subscriptions,
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 8),

                        IconButton(
                          icon: Icon(
                            _isSettingsOpen
                                ? Icons.settings_rounded
                                : Icons.settings_outlined,
                            color: const Color(0xFF4B5563),
                          ),
                          onPressed: () {
                            final isMobileLayout =
                                MediaQuery.of(context).size.width < 750;

                            if (isMobileLayout) {
                              _showMobileSettingsBottomSheet();
                            } else {
                              setState(
                                () => _isSettingsOpen = !_isSettingsOpen,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 1. MOBILE RESPONSIVE SIDEBAR
          drawer: isMobile
              ? Drawer(
                  child: LeftNavigationSidebar(
                    activeRouteName: _currentSelectedRoute,
                    isMobileDrawer: true,
                  ),
                )
              : null,

          body: Row(
            children: [
              // 2. WIDESCREEN SIDEBAR
              if (!isMobile)
                LeftNavigationSidebar(activeRouteName: _currentSelectedRoute),

              if (!isMobile)
                const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),

              // Main Application Dashboard Content Board Arena
              Expanded(
                child: RefreshIndicator(
                  color: const Color(
                    0xFF1E1E24,
                  ), // Match your dashboard theme color
                  onRefresh: _loadData, // Triggers block reloads
                  child: SingleChildScrollView(
                    // physics must be set to AlwaysScrollableScrollPhysics for refresh mechanics to work
                    // even if your widgets fit exactly inside the screen container layout.
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: EdgeInsets.all(isMobile ? 18.0 : 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TotalExpenseCard(),
                        const SizedBox(height: 24),
                        _buildResponsiveMetricGrid(isMobile || isTablet),
                        const SizedBox(height: 24),
                        // _buildResponsiveSectionsGrid(isMobile || isTablet),
                      ],
                    ),
                  ),
                ),
              ),

              // Right-Hand Settings Drawer Context Menu Pane
              if (_isSettingsOpen && !isMobile) ...[
                const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isTablet ? 330 : 380,
                  child: SettingsDrawerPanel(
                    userName: 'Abebe Kebede',
                    userEmail: 'abebe@example.com',
                    planType: 'Free Plan',
                    profileImageUrl:
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
                    onClose: () => setState(() => _isSettingsOpen = false),
                    onLogout: () async {
                      await SessionManager.logout();
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                      context.go('/login');
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void openNotificationsPanel(
    BuildContext context, {
    required List<BillModel> bills,
    required List<SubscriptionModel> subscriptions,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Notifications",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.centerRight,
          child: NotificationsPanel(
            // bills: bills,
            // subscriptions: subscriptions,
            onClose: () {
              Navigator.pop(context);
            },
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final tween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

 Widget _buildResponsiveMetricGrid(bool useCondensedGrid) {
  return BlocBuilder<BillBloc, BillState>(
    builder: (context, billState) {
      return BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, subState) {
          // ================= SAFE DATA PIPELINE =================
          final bills = billState is BillLoaded ? billState.bills : [];
          final subscriptions = subState is SubscriptionLoaded ? subState.subscriptions : [];

          // ================= BUSINESS LOGIC UTILS =================
          bool isUnpaid(String status) {
            final s = status.toLowerCase().trim();
            return s == 'unpaid' || s == 'pending';
          }

          final unpaidBillsList = bills.where((b) => isUnpaid(b.status)).toList();

          final totalUnpaidAmount = unpaidBillsList.fold<double>(
            0,
            (sum, item) => sum + item.amount,
          );

          final totalSubscriptionsAmount = subscriptions.fold<double>(
            0,
            (sum, item) => sum + item.amount,
          );

          // ================= CARD CONFIGURATION DATA OBJECTS =================
          final List<Map<String, dynamic>> gridConfigs = [
            {
              'icon': Icons.error_outline_rounded,
              'iconColor': const Color(0xFFEF4444),
              'iconBgColor': const Color(0xFFFEE2E2),
              'label': 'Unpaid Bills',
              'value': '${unpaidBillsList.length}',
              'footerText': 'View all',
              'footerColor': const Color(0xFFEF4444),
              'onTap': () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FinancialItemsListPage(
                        type: FinancialType.bills,
                        title: 'Unpaid Bills',
                        totalLabel: 'Pending Volume Total',
                        totalAmount: 'ETB ${totalUnpaidAmount.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
            },
            {
              'icon': Icons.calendar_today_rounded,
              'iconColor': const Color(0xFF8B5CF6),
              'iconBgColor': const Color(0xFFEDE9FE),
              'label': 'Subscriptions',
              'value': '${subscriptions.length}',
              'footerText': 'View active plans',
              'footerColor': const Color(0xFF8B5CF6),
              'onTap': () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FinancialItemsListPage(
                        type: FinancialType.subscriptions,
                        title: 'Active Subscriptions',
                        totalLabel: 'Monthly Commitment',
                        totalAmount: 'ETB ${totalSubscriptionsAmount.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
            },
            {
              'icon': Icons.trending_up_rounded,
              'iconColor': const Color(0xFF10B981),
              'iconBgColor': const Color(0xFFD1FAE5),
              'label': 'Average Expense',
              'value': 'ETB 3,210',
              'footerText': 'This month',
              'footerColor': const Color(0xFF10B981),
              'onTap': () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ExpenseMonthlyAnalysisPage(),
                    ),
                  ),
            },
            {
              'icon': Icons.grid_view_rounded,
              'iconColor': const Color(0xFF2563EB),
              'iconBgColor': const Color(0xFFDBEAFE),
              'label': 'Top Category',
              'value': 'Utilities',
              'footerText': 'View details',
              'footerColor': const Color(0xFF2563EB),
              'onTap': () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UtilitiesManagementPage(),
                    ),
                  ),
            },
          ];

          // ================= RESPONSIVE LAYOUT ENGINE =================
          final screenWidth = MediaQuery.of(context).size.width;

          int crossAxisCount;
          double spacing;
          double aspectRatio;

          if (screenWidth < 360) {
            crossAxisCount = 2;
            spacing = 10.0;
            aspectRatio = 0.98; // Adjusted slightly down to handle font scaling on narrow screens safely
          } else if (screenWidth < 520) {
            crossAxisCount = 2;
            spacing = 12.0;
            aspectRatio = 1.10;
          } else if (screenWidth < 850) {
            crossAxisCount = 2;
            spacing = 16.0;
            aspectRatio = 1.55;
          } else if (screenWidth < 1200) {
            crossAxisCount = 3;
            spacing = 18.0;
            aspectRatio = 1.45;
          } else {
            crossAxisCount = 4;
            spacing = 20.0;
            aspectRatio = 1.60;
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridConfigs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final config = gridConfigs[index];
              return MetricSummaryCard(
                icon: config['icon'] as IconData,
                iconColor: config['iconColor'] as Color,
                iconBgColor: config['iconBgColor'] as Color,
                label: config['label'] as String,
                value: config['value'] as String,
                footerText: config['footerText'] as String,
                footerColor: config['footerColor'] as Color,
                onTap: config['onTap'] as VoidCallback,
              );
            },
          );
        },
      );
    },
  );
}

  Widget _buildResponsiveSectionsGrid(bool useVerticalStack) {
    return BlocBuilder<BillBloc, BillState>(
      builder: (context, billState) {
        return BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, subState) {
            // ================= LOADING =================
            if (billState is BillLoading || subState is SubscriptionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ================= ERROR HANDLING =================
            if (billState is BillError) {
              return Center(child: Text(billState.message));
            }

            if (subState is SubscriptionError) {
              return Center(child: Text(subState.message));
            }

            // ❗ IMPORTANT FIX: DON'T REQUIRE BOTH LOADED
            final bills = (billState is BillLoaded)
                ? billState.bills
                : <dynamic>[];

            final subscriptions = (subState is SubscriptionLoaded)
                ? subState.subscriptions
                : <dynamic>[];

            // ================= FILTER DATA =================
            final upcomingBills = bills
                .where(
                  (b) =>
                      b.status.toLowerCase() == "upcoming" ||
                      b.status.toLowerCase() == "unpaid",
                )
                .toList();

            final activeSubscriptions = subscriptions
                .where((s) => s.status == "active")
                .toList();

            // ================= EMPTY SAFE UI =================
            if (upcomingBills.isEmpty && activeSubscriptions.isEmpty) {
              return const Center(child: Text("No data available"));
            }

            // ================= SECTIONS =================
            final sections = [
              // ================= UPCOMING BILLS =================
              DashboardSectionList(
                title: 'Upcoming Bills',
                onViewAll: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FinancialItemsListPage(
                        type: FinancialType.bills,
                        title: 'Upcoming Bills',
                        totalLabel: 'Pending Total Sum',
                        totalAmount:
                            'ETB ${upcomingBills.fold(0.0, (s, b) => s + b.amount).toStringAsFixed(2)}',
                        
                      ),
                    ),
                  );
                },
                children: upcomingBills.map((bill) {
                  return DashboardListItem(
                    leadingWidget: CircleAvatar(
                      child: Text(
                        bill.organizationName.isNotEmpty
                            ? bill.organizationName[0]
                            : "?",
                      ),
                    ),
                    title: bill.title,
                    subtitle:
                        "Due: ${bill.dueDate.toLocal().toString().split(' ')[0]}",
                    amount: "ETB ${bill.amount}",
                    amountColor: const Color(0xFFEF4444),
                  );
                }).toList(),
              ),

              // ================= SUBSCRIPTIONS =================
              DashboardSectionList(
                title: 'Subscriptions',
                onViewAll: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FinancialItemsListPage(
                        type: FinancialType.subscriptions,
                        title: 'Active Subscriptions',
                        totalLabel: 'Monthly Commitment',
                        totalAmount:
                            'ETB ${activeSubscriptions.fold(0.0, (s, b) => s + b.amount).toStringAsFixed(2)}',
                        
                      ),
                    ),
                  );
                },
                children: activeSubscriptions.map((sub) {
                  return DashboardListItem(
                    leadingWidget: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Text(
                        sub.name.isNotEmpty ? sub.name[0] : "?",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: sub.name,
                    subtitle: "Active • Monthly",
                    amount: "ETB ${sub.amount}",
                    amountColor: const Color(0xFF8B5CF6),
                  );
                }).toList(),
              ),
            ];

            // ================= LAYOUT =================
            if (useVerticalStack) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: sections
                    .map(
                      (w) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: w,
                      ),
                    )
                    .toList(),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sections
                  .map(
                    (w) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: w,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }



  String _getPlanType(UserEntity? user) {
  if (user == null) return "Free Plan";

  if (user.role == "organization") {
    return "Organization Plan";
  }

  return "Personal Plan";
}
void _showMobileSettingsBottomSheet() async {
  // 🔥 Always fetch latest user from session (not stale controller)
  final user = await SessionManager.getUser();

  if (!mounted) return;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Settings",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, _, __) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SettingsDrawerPanel(
              // =========================
              // API DATA (CLEAN + SAFE)
              // =========================
              userName: user?.fullName ?? "Guest User",
              userEmail: user?.email ?? "No Email Available",
              planType: _getPlanType(user),
              profileImageUrl: user?.profileImage ??
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user?.fullName ?? "User")}',

              onClose: () {
                Navigator.of(context).pop();
              },

              onLogout: () async {
                await SessionManager.logout();

                if (!context.mounted) return;

                Navigator.of(context).pop();
                context.go('/login');
              },
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final tween = Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
}
