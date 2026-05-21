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

  // Handle pull-to-refresh execution flow
  Future<void> _handleRefresh(BuildContext blocContext) async {
    blocContext.read<SubscriptionBloc>().add(LoadSubscriptions());
    // Give the UI animation a moment to settle naturally
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
        appBar: AppBar(
          backgroundColor: brandNavy,
          elevation: 0,
          title: const Text(
            "My Subscriptions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Builder(
          builder: (blocContext) {
            return Column(
              children: [
                // =====================================
                // INTERACTIVE SEARCH BAR TOP BANNER
                // =====================================
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  decoration: const BoxDecoration(
                    color: brandNavy,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase().trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search bills, ecosystem utilities...",
                      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: brandTeal),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // =====================================
                // REFRESHABLE CORE BLOC CONTENT BODY
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
                                    Icon(Icons.search_off_outlined, size: 64, color: Colors.grey[400]),
                                    const SizedBox(height: 16),
                                    Text(
                                      _searchQuery.isEmpty 
                                          ? "No subscriptions active yet" 
                                          : "No matches found for '$_searchQuery'",
                                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            physics: const AlwaysScrollableScrollPhysics(), 
                            itemCount: filteredList.length,
                            itemBuilder: (itemContext, index) {
                              final sub = filteredList[index];
                              final bool isActive = sub.status.toLowerCase() == "active";
                              final Color statusColor = isActive ? Colors.green : Colors.redAccent;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(width: 5, color: statusColor),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        sub.name,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: brandNavy,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: statusColor.withOpacity(0.12),
                                                        borderRadius: BorderRadius.circular(30),
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
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                                  textBaseline: TextBaseline.alphabetic,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        style: const TextStyle(color: brandNavy),
                                                        children: [
                                                          TextSpan(
                                                            text: sub.amount.toStringAsFixed(2),
                                                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                                          ),
                                                          const TextSpan(
                                                            text: " ETB",
                                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: brandTeal),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          "Next: ${sub.startDate.toLocal().toString().split(' ')[0]}",
                                                          style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                if (isActive) ...[
                                                  const Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 12),
                                                    child: Divider(height: 1, thickness: 0.8),
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 38,
                                                    child: TextButton.icon(
                                                      icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 18),
                                                      label: const Text(
                                                        "Cancel Notification Sub",
                                                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 13),
                                                      ),
                                                      style: TextButton.styleFrom(
                                                        backgroundColor: Colors.red.withOpacity(0.05),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                      ),
                                                      onPressed: () {
                                                        _showUnsubscribeDialog(blocContext, widget.token, sub.id);
                                                      },
                                                    ),
                                                  ),
                                                ] else ...[
                                                  const SizedBox(height: 14),
                                                  Text(
                                                    "✕ Deactivated / Past Bill Cycle",
                                                    style: TextStyle(color: Colors.grey[400], fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
  // CONFIRMATION MODAL DIALOG
  // =====================================
  void _showUnsubscribeDialog(BuildContext blocContext, String token, String subscriptionId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
              SizedBox(width: 10),
              Text("Cancel Billing?", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Are you sure you want to stop tracking this utility subscription notification?",
            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              child: Text("Keep Active", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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