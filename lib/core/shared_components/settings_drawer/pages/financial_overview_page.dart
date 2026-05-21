
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

  @override
  void initState() {
    super.initState();

    

  context.read<BillBloc>().add(LoadBills());
  context.read<SubscriptionBloc>().add(LoadSubscriptions());
    bills = [
      BillModel(
    id: 'b1',
    title: 'Ethio Telecom Postpaid',
    amount: 1299.00,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    status: 'unpaid',
    category: 'Internet',
    organizationName: 'Ethio Telecom X',
    recurring: true,
    notes: 'Monthly mobile + internet bill',
  ),

  BillModel(
    id: 'b2',
    title: 'EEU Electricity Grid',
    amount: 2450.00,
    dueDate: DateTime.now().add(const Duration(days: 8)),
    status: 'unpaid',
    category: 'Electricity',
    organizationName: 'EEU',
    recurring: true,
    notes: 'Monthly electricity consumption bill',
  ),

  BillModel(
    id: 'b3',
    title: 'AAWSA Water Utility',
    amount: 850.00,
    dueDate: DateTime.now().add(const Duration(days: 10)),
    status: 'unpaid',
    category: 'Water',
    organizationName: 'AAWSA',
    recurring: true,
    notes: 'Water supply bill for residential usage',
  ),

  BillModel(
    id: 'b4',
    title: 'WebSprix Fiber Internet',
    amount: 2100.00,
    dueDate: DateTime.now().subtract(const Duration(days: 2)),
    status: 'paid',
    category: 'Internet',
    organizationName: 'WebSprix',
    recurring: true,
    notes: 'High-speed fiber internet subscription',
  ),
    ];
    subscriptions = [
      SubscriptionModel(id: 's1', name: 'DSTV Premium Paket', amount: 3200.00, startDate: DateTime.now().add(const Duration(days: 1)), status: 'Active'),
      SubscriptionModel(id: 's2', name: 'Netflix Premium (4K)', amount: 499.00, startDate: DateTime.now().subtract(const Duration(days: 4)), status: 'Active'),
      SubscriptionModel(id: 's3', name: 'Spotify Family Plan', amount: 199.00, startDate: DateTime.now().subtract(const Duration(days: 12)), status: 'Active'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;
        final isTablet = constraints.maxWidth >= 750 && constraints.maxWidth < 1140;

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          
          // 1. MOBILE RESPONSIVE SIDEBAR: Attach left side menu dynamically as drawer on mobile viewports
          drawer: isMobile 
              ? Drawer(
                  child: LeftNavigationSidebar(
                    activeRouteName: _currentSelectedRoute,
                    isMobileDrawer: true,
                    onRouteSelected: (route) {
                      setState(() => _currentSelectedRoute = route);
                      Navigator.pop(context); // close drawer layer
                    },
                  ),
                )
              : null,
              
          body: Row(
            children: [
              // 2. WIDESCREEN SIDEBAR: Stays locked open as an embedded column interface element on large viewports
              if (!isMobile)
                LeftNavigationSidebar(
                  activeRouteName: _currentSelectedRoute,
                  onRouteSelected: (route) {
                    setState(() => _currentSelectedRoute = route);
                  },
                ),
                
              if (!isMobile)
                const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),

              // Main Application Dashboard Content Board Arena
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(isMobile ? 18.0 : 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(isMobile),
                      const SizedBox(height: 24),
                      
                      const TotalExpenseCard(
                        totalExpense: 'ETB 8,450.75',
                        billCount: 12,
                        subscriptionCount: 7,
                      ),
                      const SizedBox(height: 24),
                      
                      _buildResponsiveMetricGrid(isMobile || isTablet),
                      const SizedBox(height: 24),
                      
                      _buildResponsiveSectionsGrid(isMobile || isTablet),
                    ],
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
                    profileImageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
                    onClose: () => setState(() => _isSettingsOpen = false),
                    onLogout: () async {
                  // 1. Clear user data and authentication JWT token from SharedPreferences
                  await SessionManager.logout();

                  if (!context.mounted) return;

                  // 2. Close the open slide-out settings panel first
                  Navigator.of(context).pop();

                  // 3. Purge the route stack and kick the user out back to the Login Page
                  context.go('/login');
                },
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  // Header element render logic wrapping dynamic icon actions
  Widget _buildHeaderSection(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isMobile) ...[
          Builder(
            builder: (innerContext) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E1E24), size: 26),
              onPressed: () => Scaffold.of(innerContext).openDrawer(),
            ),
          ),
          const SizedBox(width: 8),
        ],

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Dashboard',
                style: TextStyle(
                  fontSize: isMobile ? 22 : 26, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF1E1E24),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your bills & subscriptions', 
                style: TextStyle(color: Colors.grey[500], fontSize: isMobile ? 12 : 14),
              ),
            ],
          ),
        ),
        
        Row(
          children: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF4B5563)),
                  onPressed: () => openNotificationsPanel(context, bills: bills, subscriptions: subscriptions),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                _isSettingsOpen ? Icons.settings_rounded : Icons.settings_outlined, 
                color: _isSettingsOpen ? const Color(0xFF2563EB) : const Color(0xFF4B5563),
              ),
              onPressed: () {
                final isMobileLayout = MediaQuery.of(context).size.width < 750;
                if (isMobileLayout) {
                  _showMobileSettingsBottomSheet();
                } else {
                  setState(() => _isSettingsOpen = !_isSettingsOpen);
                }
              },
            ),
          ],
        )
      ],
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
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget _buildResponsiveMetricGrid(bool useCondensedGrid) {
    final unpaidBillsList = bills.where((b) => b.status == 'Unpaid').toList();
    final totalUnpaidAmount = unpaidBillsList.fold<double>(0, (sum, item) => sum + item.amount);
    final totalSubscriptionsAmount = subscriptions.fold<double>(0, (sum, item) => sum + item.amount);

    final List<Widget> metrics = [
      MetricSummaryCard(
        icon: Icons.error_outline_rounded,
        iconColor: const Color(0xFFEF4444),
        iconBgColor: const Color(0xFFFEE2E2),
        label: 'Unpaid Bills',
        value: '${unpaidBillsList.length}',
        footerText: 'View all',
        footerColor: const Color(0xFFEF4444),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FinancialItemsListPage(
                title: 'Unpaid Bills',
                totalLabel: 'Pending Volume Total',
                totalAmount: 'ETB ${totalUnpaidAmount.toStringAsFixed(2)}',
                items: unpaidBillsList.map((bill) => DashboardListItem(
                  leadingWidget: const CircleAvatar(
                    backgroundColor: Color(0xFFFEE2E2), 
                    child: Icon(Icons.receipt_long_rounded, color: Color(0xFFEF4444), size: 18),
                  ),
                  title: bill.title,
                  subtitle: 'Due: ${bill.dueDate.day}/${bill.dueDate.month}/${bill.dueDate.year}',
                  amount: 'ETB ${bill.amount.toStringAsFixed(2)}',
                  amountColor: const Color(0xFFEF4444),
                )).toList(),
              ),
            ),
          );
        },
      ),
      MetricSummaryCard(
        icon: Icons.calendar_today_rounded,
        iconColor: const Color(0xFF8B5CF6),
        iconBgColor: const Color(0xFFEDE9FE),
        label: 'Subscriptions',
        value: '${subscriptions.length}',
        footerText: 'View active plans',
        footerColor: const Color(0xFF8B5CF6),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FinancialItemsListPage(
                title: 'Active Subscriptions',
                totalLabel: 'Monthly Commitment',
                totalAmount: 'ETB ${totalSubscriptionsAmount.toStringAsFixed(2)}',
                items: subscriptions.map((sub) => DashboardListItem(
                  leadingWidget: CircleAvatar(
                    backgroundColor: const Color(0xFF0F172A), 
                    child: Text(sub.name.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  title: sub.name,
                  subtitle: 'Status: ${sub.status} • Monthly',
                  amount: 'ETB ${sub.amount.toStringAsFixed(2)}',
                  amountColor: const Color(0xFF8B5CF6),
                )).toList(),
              ),
            ),
          );
        },
      ),
      MetricSummaryCard(
        icon: Icons.trending_up_rounded,
        iconColor: const Color(0xFF10B981),
        iconBgColor: const Color(0xFFD1FAE5),
        label: 'Average Expense',
        value: 'ETB 3,210',
        footerText: 'This month',
        footerColor: const Color(0xFF10B981),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ExpenseMonthlyAnalysisPage()),
          );
        },
      ),
      MetricSummaryCard(
        icon: Icons.grid_view_rounded,
        iconColor: const Color(0xFF2563EB),
        iconBgColor: const Color(0xFFDBEAFE),
        label: 'Top Category',
        value: 'Utilities',
        footerText: 'View details',
        footerColor: const Color(0xFF2563EB),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const UtilitiesManagementPage()),
          );
        },
      ),
    ];

    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 520) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: metrics.map((card) {
              return Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: SizedBox(
                  width: screenWidth * 0.44, 
                  height: 142,
                  child: card,
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    int crossAxisCount;
    if (screenWidth < 850) {
      crossAxisCount = 2;
    } else if (screenWidth < 1200) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 142,
      ),
      itemBuilder: (context, index) => metrics[index],
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
              .where((b) =>
                  b.status.toLowerCase() == "upcoming" ||
                  b.status.toLowerCase() == "unpaid")
              .toList();

          final activeSubscriptions = subscriptions
              .where((s) => s.status == "active")
              .toList();

          // ================= EMPTY SAFE UI =================
          if (upcomingBills.isEmpty && activeSubscriptions.isEmpty) {
            return const Center(
              child: Text("No data available"),
            );
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
        title: 'Upcoming Bills',
        totalLabel: 'Pending Total Sum',
        totalAmount:
            'ETB ${upcomingBills.fold(0.0, (s, b) => s + b.amount).toStringAsFixed(2)}',
        items: upcomingBills.map((bill) {
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
        title: 'Active Subscriptions',
        totalLabel: 'Monthly Commitment',
        totalAmount:
            'ETB ${activeSubscriptions.fold(0.0, (s, b) => s + b.amount).toStringAsFixed(2)}',
        items: activeSubscriptions.map((sub) {
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
                  .map((w) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: w,
                      ))
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

  void _showMobileSettingsBottomSheet() {
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
                userName: 'Dessalew Fentahun',
                userEmail: 'dessalew@example.com',
                planType: 'Premium Workspace',
                profileImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                onClose: () {
                  Navigator.of(context).pop();
                },
                onLogout: () async {
                  // 1. Clear user data and authentication JWT token from SharedPreferences
                  await SessionManager.logout();

                  if (!context.mounted) return;

                  // 2. Close the open slide-out settings panel first
                  Navigator.of(context).pop();

                  // 3. Purge the route stack and kick the user out back to the Login Page
                  context.go('/login');
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}