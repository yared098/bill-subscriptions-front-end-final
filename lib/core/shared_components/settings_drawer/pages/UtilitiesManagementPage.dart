import 'package:bill_subscription_notifier/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_bloc.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_event.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_state.dart';
import 'package:bill_subscription_notifier/features/subscriptions/data/models/subscription_model.dart';

class UtilitiesManagementPage extends StatefulWidget {
  const UtilitiesManagementPage({super.key});

  @override
  State<UtilitiesManagementPage> createState() =>
      _UtilitiesManagementPageState();
}

class _UtilitiesManagementPageState extends State<UtilitiesManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>().add(LoadSubscriptions());
  }

  void _toggleSubscription(BuildContext context, String id, bool isActive) {
    context.read<SubscriptionBloc>().add(
          UnsubscribeSubscription(
            id: id,
            reason: isActive
                ? "User unsubscribed from utility service"
                : "User re-subscribed",
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Utility Services',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ===================== BODY =====================
      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubscriptionError) {
            return Center(child: Text(state.message));
          }

          if (state is SubscriptionLoaded) {
            // final List<SubscriptionModel> utilities = state.subscriptions;
            final List<SubscriptionEntity> utilities = state.subscriptions;

            final activeUtilities = utilities
                .where((u) => u.status.toLowerCase() == 'active')
                .toList();

            final totalActiveCommitment = activeUtilities.fold<double>(
              0,
              (sum, item) => sum + item.amount,
            );

            return Column(
              children: [
                // ================= TOP SUMMARY =================
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL UTILITY FLOW',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Active Services',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'ETB ${totalActiveCommitment.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= LIST =================
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: utilities.length,
                    itemBuilder: (context, index) {
                      final item = utilities[index];

                      final bool isActive =
                          item.status.toLowerCase() == "active";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),

                          // ================= ICON =================
                          leading: CircleAvatar(
                            backgroundColor: isActive
                                ? const Color(0xFFDBEAFE)
                                : const Color(0xFFF1F5F9),
                            child: Icon(
                              isActive
                                  ? Icons.power
                                  : Icons.power_off_rounded,
                              color: isActive
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),

                          // ================= TITLE =================
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),

                          subtitle: Text(
                            'ETB ${item.amount} • ${item.status}',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),

                          // ================= ACTION =================
                          trailing: OutlinedButton(
                            onPressed: () => _toggleSubscription(
                              context,
                              item.id,
                              isActive,
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isActive
                                  ? Colors.white
                                  : const Color(0xFF2563EB),
                              side: BorderSide(
                                color: isActive
                                    ? const Color(0xFFEF4444)
                                    : Colors.transparent,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              isActive ? "Unsubscribe" : "Subscribe",
                              style: TextStyle(
                                color: isActive
                                    ? const Color(0xFFEF4444)
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}