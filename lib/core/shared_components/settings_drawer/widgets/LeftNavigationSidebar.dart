import 'package:flutter/material.dart';

class LeftNavigationSidebar extends StatelessWidget {
  final String activeRouteName;
  final Function(String route) onRouteSelected;
  final VoidCallback? onUpgradeTap;
  final VoidCallback? onLogoutTap;
  final bool isMobileDrawer;

  const LeftNavigationSidebar({
    super.key,
    this.activeRouteName = 'Overview',
    required this.onRouteSelected,
    this.onUpgradeTap,
    this.onLogoutTap,
    this.isMobileDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: SafeArea(
        // Disable safe area top pads inside custom main scaffold drawers to prevent double layouts
        top: !isMobileDrawer, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Branding Logo Header Grouping
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Text(
                  'BillFlow',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Navigation Route Option Lists
            Expanded(
              child: Column(
                children: [
                  _buildNavItem(Icons.grid_view_rounded, 'Overview'),
                  _buildNavItem(Icons.description_outlined, 'Bills'),
                  _buildNavItem(Icons.calendar_today_rounded, 'Subscriptions'),
                  _buildNavItem(Icons.credit_card_rounded, 'Payments'),
                  _buildNavItem(Icons.analytics_outlined, 'Reports'),
                  _buildNavItem(Icons.settings_outlined, 'Settings'),
                ],
              ),
            ),

            // Modern Floating Promotional Upsell Card Frame Panel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: Colors.amber[700], size: 18),
                      const SizedBox(width: 6),
                      const Text(
                        'Upgrade to Premium',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Get more features and advanced insights',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 11, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: onUpgradeTap,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2563EB)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Upgrade Now',
                        style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fixed Logout Footer Action Item Row
            InkWell(
              onTap: onLogoutTap,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title) {
    bool isActive = activeRouteName == title;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: InkWell(
        onTap: () => onRouteSelected(title),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}