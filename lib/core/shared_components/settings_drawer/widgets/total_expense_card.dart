import 'package:flutter/material.dart';

class TotalExpenseCard extends StatefulWidget {
  final String totalExpense;
  final int billCount;
  final int subscriptionCount;
  final VoidCallback? onTap;

  const TotalExpenseCard({
    super.key,
    required this.totalExpense,
    required this.billCount,
    required this.subscriptionCount,
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
              color: const Color(0xFF7C3AED).withOpacity(_isHovered ? 0.3 : 0.15),
              blurRadius: _isHovered ? 24 : 16,
              offset: _isHovered ? const Offset(0, 12) : const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.05),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 20.0 : 28.0),
              child: Stack(
                children: [
                  // Stylized abstract background vector mask overlay
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

                  // Content Layout Core Container
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Total Monthly Expense',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85), 
                                fontSize: 14, 
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(radius: 3, backgroundColor: Colors.greenAccent),
                                SizedBox(width: 6),
                                Text('Live Tracker', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // FIX: Wrapped FittedBox inside ConstrainedBox to correctly handle maxWidth constraints!
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.totalExpense,
                            style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 36, 
                              fontWeight: FontWeight.bold, 
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 24 : 32),
                      
                      // Translucent contextual counter badges
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildPremiumStatBadge('${widget.billCount}', 'Active Bills', Icons.receipt_long_rounded),
                          _buildPremiumStatBadge('${widget.subscriptionCount}', 'Subscriptions', Icons.autorenew_rounded),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumStatBadge(String count, String label, IconData contextualIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(contextualIcon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Text(
            count, 
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 6),
          Text(
            label, 
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}