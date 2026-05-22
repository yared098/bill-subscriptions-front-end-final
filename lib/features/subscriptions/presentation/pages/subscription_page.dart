import 'package:bill_subscription_notifier/core/shared_components/settings_drawer/widgets/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_subscriptions.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../data/datasources/subscription_remote_datasource.dart';

import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';

class SubscriptionPage extends StatefulWidget {
  final String token;

  const SubscriptionPage({super.key, required this.token});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh(BuildContext blocContext) async {
    blocContext.read<SubscriptionBloc>().add(LoadSubscriptions());
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    const Color brandNavy = Color(0xFF1A365D);
    const Color brandTeal = Color(0xFF008080);

    return BlocProvider(
      create: (_) => SubscriptionBloc(
        GetSubscriptions(
          SubscriptionRepositoryImpl(
            SubscriptionRemoteDataSource(),
          ),
        ),
      )..add(LoadSubscriptions()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBars.primary(
          title: "My Subscriptions",
        ),
        body: Builder(
          builder: (blocContext) {
            return Column(
              children: [
                // =====================================
                // CLEAN WHITE SEARCH BAR ROW
                // =====================================
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: Colors.black87, 
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase().trim();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search subscriptions or utilities...",
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: brandTeal, size: 22),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = "";
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                // =====================================
                // CORE CONTENT BODY
                // =====================================
                Expanded(
                  child: RefreshIndicator(
                    color: brandTeal,
                    backgroundColor: Colors.white,
                    onRefresh: () => _handleRefresh(blocContext),
                    child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
                      builder: (stateContext, state) {
                        if (state is SubscriptionLoading) {
                          return const Center(
                            child: CircularProgressIndicator(color: brandTeal),
                          );
                        }

                        if (state is SubscriptionError) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Container(
                              height: MediaQuery.of(stateContext).size.height * 0.6,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                                  const SizedBox(height: 12),
                                  Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Swipe down to reload data",
                                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state is SubscriptionLoaded) {
                          final filteredList = state.subscriptions.where((sub) {
                            return sub.name.toLowerCase().contains(_searchQuery);
                          }).toList();

                          if (filteredList.isEmpty) {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height: MediaQuery.of(stateContext).size.height * 0.6,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search_off_outlined, size: 54, color: Colors.grey[350]),
                                    const SizedBox(height: 16),
                                    Text(
                                      _searchQuery.isEmpty 
                                          ? "No active subscriptions found" 
                                          : "No matches for '$_searchQuery'",
                                      style: TextStyle(color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            physics: const AlwaysScrollableScrollPhysics(), 
                            itemCount: filteredList.length,
                            itemBuilder: (itemContext, index) {
                              final sub = filteredList[index];
                              final bool isActive = sub.status.toLowerCase() == "active";
                              final Color statusColor = isActive ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
                              final Color statusBg = isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Top Header Section
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            margin: const EdgeInsets.only(top: 6, right: 12),
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  sub.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: brandNavy,
                                                    height: 1.2,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                    Text(
                                                    "Ref: #${(sub.id.length > 6 ? sub.id.substring(sub.id.length - 6) : sub.id).toUpperCase()}",
                                                    style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500),
                                                  ),
                                                                                                ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: statusBg,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              sub.status.toUpperCase(),
                                              style: TextStyle(
                                                color: statusColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 14),
                                        child: Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE)),
                                      ),
                                      
                                      // Pricing and Date Layout Section
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        // alignItems: Alignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: brandNavy),
                                              children: [
                                                TextSpan(
                                                  text: sub.amount.toStringAsFixed(2),
                                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                                ),
                                                const TextSpan(
                                                  text: " ETB",
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: brandTeal),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[400]),
                                              const SizedBox(width: 6),
                                              Text(
                                                "Next: ${sub.startDate.toLocal().toString().split(' ')[0]}",
                                                style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      // Footer Section Actions
                                      if (isActive) ...[
                                        const SizedBox(height: 14),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(8),
                                            onTap: () => _showUnsubscribeDialog(blocContext, widget.token, sub.id),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Icon(Icons.notifications_off_outlined, color: Colors.redAccent, size: 16),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "Cancel Alerts",
                                                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        const SizedBox(height: 12),
                                        Text(
                                          "✓ Past billing execution path complete",
                                          style: TextStyle(color: Colors.grey[400], fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =====================================
  // MODAL CONFIRMATION SYSTEM DIALOG
  // =====================================
  void _showUnsubscribeDialog(BuildContext blocContext, String token, String subscriptionId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 26),
              SizedBox(width: 10),
              Text("Cancel Billing?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color:Colors.green)),
            ],
          ),
          content: const Text(
            "Are you sure you want to stop tracking this utility subscription notification?",
            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              child: Text("Keep Active", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Yes, Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pop(dialogContext);
                blocContext.read<SubscriptionBloc>().add(
                      UnsubscribeSubscription(
                        id: subscriptionId,
                        reason: "User requested cancellation via mobile panel app UI",
                      ),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}