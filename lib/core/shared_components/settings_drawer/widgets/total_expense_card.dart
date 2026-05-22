import 'package:bill_subscription_notifier/features/bills/presentation/bloc/bill_bloc.dart';
import 'package:bill_subscription_notifier/features/bills/presentation/bloc/bill_state.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_bloc.dart';
import 'package:bill_subscription_notifier/features/subscriptions/presentation/bloc/subscription_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalExpenseCard extends StatefulWidget {
  final VoidCallback? onTap;

  const TotalExpenseCard({
    super.key,
    this.onTap,
  });

  @override
  State<TotalExpenseCard> createState() => _TotalExpenseCardState();
}

class _TotalExpenseCardState extends State<TotalExpenseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    // Theme Design Tokens
    const primaryBlue = Color(0xFF2563EB);
    const deepObsidian = Color(0xFF1E293B);

    return BlocBuilder<BillBloc, BillState>(
      builder: (context, billState) {
        return BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, subState) {
            // ================= REAL DATA BUSINESS PIPELINE =================
            double totalExpense = 0;
            int billCount = 0;
            int subscriptionCount = 0;

            // BILLS ACCUMULATION
            if (billState is BillLoaded) {
              billCount = billState.bills.length;
              totalExpense += billState.bills.fold(
                0,
                (sum, bill) => sum + bill.amount,
              );
            }

            // SUBSCRIPTIONS ACCUMULATION
            if (subState is SubscriptionLoaded) {
              subscriptionCount = subState.subscriptions.length;
              totalExpense += subState.subscriptions.fold(
                0,
                (sum, sub) => sum + sub.amount,
              );
            }

            return MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                transform: _isHovered
                    ? (Matrix4.identity()..translate(0, -4, 0))
                    : Matrix4.identity(),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryBlue, deepObsidian],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(_isHovered ? 0.24 : 0.12),
                      blurRadius: _isHovered ? 28 : 16,
                      offset: _isHovered ? const Offset(0, 12) : const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
                      child: Stack(
                        children: [
                          // Background Geometric Ambient Shape Mask
                          Positioned(
                            right: -15,
                            bottom: -15,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _isHovered ? 0.22 : 0.08,
                              child: const Icon(
                                Icons.analytics_rounded,
                                size: 150,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Foreground Layout Content
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Total Monthly Expense',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFFE2E8F0),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.08),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 3.5,
                                          backgroundColor: Color(0xFF10B981), // Solid Emerald Green
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Live Tracker',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Total Numeric Layout Display
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "ETB ${totalExpense.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.8,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 24 : 32),

                              // Metadata Info Badges Layout Block
                              Wrap(
                                spacing: 12,
                                runSpacing: 10,
                                children: [
                                  _buildBadge(
                                    billCount.toString(),
                                    "Active Bills",
                                    Icons.receipt_long_rounded,
                                  ),
                                  _buildBadge(
                                    subscriptionCount.toString(),
                                    "Subscriptions",
                                    Icons.autorenew_rounded,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBadge(String count, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFFCBD5E1)),
          const SizedBox(width: 8),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}