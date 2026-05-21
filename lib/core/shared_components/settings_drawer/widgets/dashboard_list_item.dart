import 'package:flutter/material.dart';

class DashboardListItem extends StatelessWidget {
  final Widget leadingWidget;
  final String title;
  final String subtitle;
  final String amount;
  final Color? amountColor;
  final Widget? trailingWidget;

  const DashboardListItem({
    super.key,
    required this.leadingWidget,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.amountColor,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (trailingWidget != null) trailingWidget!,
              Text(
                amount,
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold, 
                  color: amountColor ?? const Color(0xFF1E1E24)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}