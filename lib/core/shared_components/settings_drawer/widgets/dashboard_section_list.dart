import 'package:flutter/material.dart';

class DashboardSectionList extends StatefulWidget {
  final String title;
  final VoidCallback onViewAll;
  final List<Widget> children;

  const DashboardSectionList({
    super.key,
    required this.title,
    required this.onViewAll,
    required this.children,
  });

  @override
  State<DashboardSectionList> createState() => _DashboardSectionListState();
}

class _DashboardSectionListState extends State<DashboardSectionList> {
  bool _isButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    // Restrict list to a maximum safety threshold of 4 items for dense dashboard aesthetics
    final visibleItems = widget.children.length > 4
        ? widget.children.sublist(0, 4)
        : widget.children;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0), // Modern slate border line
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= CONTAINER HEADER SECTION =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A), // Dark obsidian body text
                  letterSpacing: -0.2,
                ),
              ),
              MouseRegion(
                onEnter: (_) => setState(() => _isButtonHovered = true),
                onExit: (_) => setState(() => _isButtonHovered = false),
                child: TextButton(
                  onPressed: widget.onViewAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory, // Keep text interaction clean
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 13,
                          color: _isButtonHovered ? const Color(0xFF1D4ED8) : const Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: _isButtonHovered ? const Color(0xFF1D4ED8) : const Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ================= LINE ITEMS LAYOUT ENGINE =================
          if (visibleItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'No items available yet',
                  style: TextStyle(
                    color: const Color(0xFF64748B).withOpacity(0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleItems.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFF1F5F9), // Smooth grey item separations
                height: 1,
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? 0 : 12.0,
                    bottom: index == visibleItems.length - 1 ? 0 : 12.0,
                  ),
                  child: visibleItems[index],
                );
              },
            ),
        ],
      ),
    );
  }
}