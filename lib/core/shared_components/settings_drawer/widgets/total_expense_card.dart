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

    return BlocBuilder<BillBloc, BillState>(
      builder: (context, billState) {
        return BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, subState) {

            // ================= REAL DATA =================
            double totalExpense = 0;
            int billCount = 0;
            int subscriptionCount = 0;

            // BILLS
            if (billState is BillLoaded) {
              billCount = billState.bills.length;

              totalExpense += billState.bills.fold(
                0,
                (sum, bill) => sum + bill.amount,
              );
            }

            // SUBSCRIPTIONS
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
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                transform: _isHovered
                    ? (Matrix4.identity()..translate(0, -4, 0))
                    : Matrix4.identity(),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED)
                          .withOpacity(_isHovered ? 0.3 : 0.15),
                      blurRadius: _isHovered ? 24 : 16,
                      offset: _isHovered
                          ? const Offset(0, 12)
                          : const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
                      child: Stack(
                        children: [
                          // background icon
                          Positioned(
                            right: -10,
                            bottom: -10,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _isHovered ? 0.25 : 0.12,
                              child: const Icon(
                                Icons.stacked_line_chart_rounded,
                                size: 140,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // CONTENT
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
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 3,
                                          backgroundColor: Colors.greenAccent,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Live Tracker',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 12),

                              // TOTAL EXPENSE
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.6,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "ETB ${totalExpense.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: isSmallScreen ? 24 : 32),

                              // BADGES
                              Wrap(
                                spacing: 16,
                                runSpacing: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}