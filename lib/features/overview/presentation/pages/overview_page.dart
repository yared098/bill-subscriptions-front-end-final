import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_overview.dart';

import '../../data/repositories/overview_repository_impl.dart';
import '../../data/datasources/overview_remote_datasource.dart';

import '../bloc/overview_bloc.dart';
import '../bloc/overview_event.dart';
import '../bloc/overview_state.dart';

class OverviewPage extends StatelessWidget {
  final String token;

  const OverviewPage({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OverviewBloc(
        GetOverview(
          OverviewRepositoryImpl(
            OverviewRemoteDataSource(),
          ),
        ),
      )..add(LoadOverview(token)),

      child: Scaffold(
        backgroundColor: const Color(
          0xFFF5F7FB,
        ),
        endDrawer: _buildSettingsDrawer(context), // ✅ ADD THIS


        body: SafeArea(
          child:
              BlocBuilder<
                OverviewBloc,
                OverviewState
              >(
                builder: (
                  context,
                  state,
                ) {
                  // ======================
                  // LOADING
                  // ======================
                  if (state
                      is OverviewLoading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  // ======================
                  // ERROR
                  // ======================
                  if (state
                      is OverviewError) {
                    return Center(
                      child: Text(
                        state.message,
                      ),
                    );
                  }

                  // ======================
                  // LOADED
                  // ======================
                  if (state
                      is OverviewLoaded) {
                    final dashboard =
                        state.dashboard;

                    final analytics =
                        state.analytics;

                    return RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<
                              OverviewBloc
                            >()
                            .add(
                              LoadOverview(
                                token,
                              ),
                            );
                      },

                      child:
                          SingleChildScrollView(
                            physics:
                                const AlwaysScrollableScrollPhysics(),

                            padding:
                                const EdgeInsets.all(
                                  20,
                                ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                // ======================
                                // HEADER
                                // ======================
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,

                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: const [
                                        Text(
                                          "Dashboard",
                                          style: TextStyle(
                                            fontSize:
                                                28,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        SizedBox(
                                          height:
                                              4,
                                        ),

                                        Text(
                                          "Track your bills & subscriptions",
                                          style: TextStyle(
                                            color:
                                                Colors
                                                    .grey,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Container(
                                    //   padding:
                                    //       const EdgeInsets.all(
                                    //         12,
                                    //       ),

                                    //   decoration: BoxDecoration(
                                    //     color:
                                    //         Colors
                                    //             .white,

                                    //     borderRadius:
                                    //         BorderRadius.circular(
                                    //           18,
                                    //         ),
                                    //   ),

                                    //   child: const Icon(
                                    //     Icons
                                    //         .notifications_none,
                                    //   ),
                                    // ),
                                    Row(
  children: [
    // =========================
    // NOTIFICATIONS ICON
    // =========================
    GestureDetector(
      onTap: () {
        // TODO: go to notifications page
        // context.push('/notifications');
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.notifications_none,
          color: Colors.black87,
        ),
      ),
    ),

    const SizedBox(width: 10),

    // =========================
    // SETTINGS / DRAWER ICON
    // =========================
    Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Scaffold.of(context).openEndDrawer();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.settings,
            color: Colors.black87,
          ),
        ),
      ),
    ),
  ],
),
                                  ],
                                ),

                                const SizedBox(
                                  height: 25,
                                ),

                                // ======================
                                // TOTAL BALANCE CARD
                                // ======================
                                Container(
                                  width:
                                      double.infinity,

                                  padding:
                                      const EdgeInsets.all(
                                        24,
                                      ),

                                  decoration: BoxDecoration(
                                    gradient:
                                        const LinearGradient(
                                          colors: [
                                            Color(
                                              0xFF5B67F1,
                                            ),
                                            Color(
                                              0xFF7B4DFF,
                                            ),
                                          ],
                                        ),

                                    borderRadius:
                                        BorderRadius.circular(
                                          30,
                                        ),
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [
                                      const Text(
                                        "Total Monthly Expense",
                                        style: TextStyle(
                                          color:
                                              Colors
                                                  .white70,

                                          fontSize:
                                              16,
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            10,
                                      ),

                                      Text(
                                        "ETB ${dashboard.totalMonthlyExpenses.toStringAsFixed(2)}",

                                        style: const TextStyle(
                                          color:
                                              Colors
                                                  .white,

                                          fontSize:
                                              34,

                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            20,
                                      ),

                                      Row(
                                        children: [
                                          _miniStat(
                                            "Bills",
                                            dashboard
                                                .totalBills
                                                .toStringAsFixed(
                                                  0,
                                                ),
                                          ),

                                          const SizedBox(
                                            width:
                                                25,
                                          ),

                                          _miniStat(
                                            "Subscriptions",
                                            dashboard
                                                .totalSubscriptions
                                                .toStringAsFixed(
                                                  0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 25,
                                ),

                                // ======================
                                // QUICK STATS
                                // ======================
                                GridView(
                                  shrinkWrap:
                                      true,

                                  physics:
                                      const NeverScrollableScrollPhysics(),

                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            2,

                                        mainAxisSpacing:
                                            14,

                                        crossAxisSpacing:
                                            14,

                                        childAspectRatio:
                                            1.2,
                                      ),

                                  children: [
                                    _buildCard(
                                      title:
                                          "Unpaid Bills",

                                      value:
                                          dashboard
                                              .unpaidBillsCount
                                              .toString(),

                                      icon:
                                          Icons
                                              .warning_amber_rounded,

                                      color:
                                          Colors
                                              .red,
                                    ),

                                    _buildCard(
                                      title:
                                          "Top Category",

                                      value:
                                          analytics.topCategory ??
                                          "N/A",

                                      icon:
                                          Icons
                                              .category,

                                      color:
                                          Colors
                                              .blue,
                                    ),

                                    _buildCard(
                                      title:
                                          "Average Expense",

                                      value:
                                          "ETB ${analytics.averageExpense.toStringAsFixed(0)}",

                                      icon:
                                          Icons
                                              .analytics,

                                      color:
                                          Colors
                                              .green,
                                    ),

                                    _buildCard(
                                      title:
                                          "Highest Month",

                                      value:
                                          analytics
                                              .highestMonth,

                                      icon:
                                          Icons
                                              .calendar_month,

                                      color:
                                          Colors
                                              .deepPurple,
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 30,
                                ),

                                // ======================
                                // UPCOMING BILLS
                                // ======================
                                _sectionTitle(
                                  "Upcoming Bills",
                                  Icons
                                      .receipt_long,
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                dashboard
                                        .upcomingBills
                                        .isEmpty
                                    ? _emptyWidget(
                                      "No upcoming bills",
                                    )
                                    : Column(
                                      children:
                                          dashboard
                                              .upcomingBills
                                              .map(
                                                (
                                                  bill,
                                                ) => _buildListTile(
                                                  title:
                                                      bill.title,

                                                  subtitle:
                                                      "Due: ${bill.dueDate.toString().split(' ')[0]}",

                                                  amount:
                                                      "ETB ${bill.amount}",

                                                  icon:
                                                      Icons.receipt_long,

                                                  color:
                                                      Colors.orange,
                                                ),
                                              )
                                              .toList(),
                                    ),

                                const SizedBox(
                                  height: 30,
                                ),

                                // ======================
                                // SUBSCRIPTIONS
                                // ======================
                                _sectionTitle(
                                  "Subscriptions",
                                  Icons
                                      .subscriptions,
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                dashboard
                                        .recentSubscriptions
                                        .isEmpty
                                    ? _emptyWidget(
                                      "No subscriptions found",
                                    )
                                    : Column(
                                      children:
                                          dashboard
                                              .recentSubscriptions
                                              .map(
                                                (
                                                  sub,
                                                ) => _buildListTile(
                                                  title:
                                                      sub.name,

                                                  subtitle:
                                                      sub.status,

                                                  amount:
                                                      "ETB ${sub.amount}",

                                                  icon:
                                                      Icons.subscriptions,

                                                  color:
                                                      Colors.purple,
                                                ),
                                              )
                                              .toList(),
                                    ),

                                const SizedBox(
                                  height: 30,
                                ),

                                // ======================
                                // RECENT BILLS
                                // ======================
                                _sectionTitle(
                                  "Recent Bills",
                                  Icons.history,
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                dashboard
                                        .recentBills
                                        .isEmpty
                                    ? _emptyWidget(
                                      "No recent bills",
                                    )
                                    : Column(
                                      children:
                                          dashboard
                                              .recentBills
                                              .map(
                                                (
                                                  bill,
                                                ) => _buildListTile(
                                                  title:
                                                      bill.title,

                                                  subtitle:
                                                      bill.category,

                                                  amount:
                                                      "ETB ${bill.amount}",

                                                  icon:
                                                      Icons.history,

                                                  color:
                                                      Colors.green,
                                                ),
                                              )
                                              .toList(),
                                    ),

                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                    );
                  }

                  return const SizedBox();
                },
              ),
        ),
     
      ),
    );
  }

  // ======================
  // MINI STAT
  // ======================
  Widget _miniStat(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          value,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        Text(
          title,

          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // ======================
  // SECTION TITLE
  // ======================
  Widget _sectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon),

        const SizedBox(width: 8),

        Text(
          title,

          style: const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ======================
  // CARD
  // ======================
  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
              24,
            ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),

            blurRadius: 10,

            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [
          CircleAvatar(
            backgroundColor:
                color.withOpacity(0.1),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              Text(
                value,

                style: const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight
                          .bold,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                title,

                style: TextStyle(
                  color:
                      Colors
                          .grey
                          .shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ======================
  // LIST TILE
  // ======================
  Widget _buildListTile({
    required String title,
    required String subtitle,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
              22,
            ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.03),

            blurRadius: 10,

            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),

        leading: CircleAvatar(
          radius: 25,

          backgroundColor:
              color.withOpacity(0.12),

          child: Icon(
            icon,
            color: color,
          ),
        ),

        title: Text(
          title,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle: Padding(
          padding:
              const EdgeInsets.only(
                top: 4,
              ),

          child: Text(subtitle),
        ),

        trailing: Text(
          amount,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,

            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ======================
  // EMPTY
  // ======================
  Widget _emptyWidget(
    String text,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        30,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
              24,
            ),
      ),

      child: Column(
        children: [
          Icon(
            Icons.inbox,
            size: 50,
            color:
                Colors.grey.shade400,
          ),

          const SizedBox(height: 10),

          Text(
            text,

            style: TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
Widget _buildSettingsDrawer(BuildContext context) {
  return Drawer(
    width: MediaQuery.of(context).size.width * 0.78,
    child: Column(
      children: [
        // =========================
        // HEADER
        // =========================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 60,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF5B67F1),
                Color(0xFF7B4DFF),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 30),
              ),
              SizedBox(height: 12),
              Text(
                "My Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Manage your financial settings",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // =========================
        // MENU ITEMS
        // =========================
        Expanded(
          child: ListView(
            children: [
              _drawerItem(
                icon: Icons.person,
                title: "Profile",
                onTap: () {},
              ),

              _drawerItem(
                icon: Icons.credit_card,
                title: "Payment Methods",
                onTap: () {},
              ),

              _drawerItem(
                icon: Icons.subscriptions,
                title: "Subscriptions",
                onTap: () {},
              ),

              _drawerItem(
                icon: Icons.receipt_long,
                title: "Bills",
                onTap: () {},
              ),

              _drawerItem(
                icon: Icons.notifications,
                title: "Notifications",
                onTap: () {},
              ),

              const Divider(),

              _drawerItem(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {},
              ),

              _drawerItem(
                icon: Icons.help_outline,
                title: "Help & Support",
                onTap: () {},
              ),
            ],
          ),
        ),

        // =========================
        // LOGOUT
        // =========================
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(14),
              ),
              onPressed: () {
                // TODO: clear session + redirect
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ),
        ),
      ],
    ),
  );
}
Widget _drawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.deepPurple),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    onTap: onTap,
  );
}
}