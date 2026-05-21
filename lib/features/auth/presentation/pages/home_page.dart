import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bill_subscription_notifier/features/auth/core/session/session_manager.dart';

class HomeShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeShell({
    super.key,
    required this.navigationShell,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  bool isSidebarOpen = true;

  void _navigate(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  // Resolves titles based on active route index
  String _getScreenTitle(int index) {
    switch (index) {
      case 0:
        return "Dashboard Overview";
      case 1:
        return "Bills Management";
      case 2:
        return "Subscriptions Control";
      case 3:
        return "Payments & Receipts";
      case 4:
        return "Notifications";
      default:
        return "Notifier Portal";
    }
  }

  // Modernized confirmation dialog before session clears
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text("Sign Out"),
            ],
          ),
          content: const Text("Are you sure you want to log out of your account?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext); // Close dialog
                await SessionManager.logout(); // Flush local cache token states
                if (context.mounted) {
                  context.go('/login'); // Trigger AppRouter redirect pipeline
                }
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Subtle application background shade
      body: Row(
        children: [
          // ================= BEAUTIFIED SIDEBAR =================
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: isSidebarOpen ? 260 : 85,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2D), // Deep rich professional slate dark tone
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                )
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // BRAND HEADER AREA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: isSidebarOpen ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                    children: [
                      if (isSidebarOpen)
                        const Row(
                          children: [
                            Icon(Icons.bolt, color: Colors.blueAccent, size: 28),
                            SizedBox(width: 8),
                            Text(
                              "NOTIFIER",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      IconButton(
                        onPressed: () => setState(() => isSidebarOpen = !isSidebarOpen),
                        icon: Icon(
                          isSidebarOpen ? Icons.chevron_left_rounded : Icons.menu_rounded,
                          color: Colors.white70,
                        ),
                        tooltip: isSidebarOpen ? "Collapse Menu" : "Expand Menu",
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Divider(color: Colors.white10, thickness: 1),
                ),
                const SizedBox(height: 10),

                // NAVIGATION ITEMS SEQUENCE
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _sidebarItem(icon: Icons.dashboard_rounded, title: "Dashboard", index: 0, activeIndex: currentIndex),
                      _sidebarItem(icon: Icons.receipt_long_rounded, title: "Bills", index: 1, activeIndex: currentIndex),
                      _sidebarItem(icon: Icons.subscriptions_rounded, title: "Subscriptions", index: 2, activeIndex: currentIndex),
                      _sidebarItem(icon: Icons.account_balance_wallet_rounded, title: "Payments", index: 3, activeIndex: currentIndex),
                      _sidebarItem(icon: Icons.notifications_active_rounded, title: "Notifications", index: 4, activeIndex: currentIndex),
                    ],
                  ),
                ),
                
                // USER CONSOLE FOOTER SECTION IN SIDEBAR
                if (isSidebarOpen) ...[
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent.withOpacity(0.2),
                          child: const Icon(Icons.person_rounded, color: Colors.blueAccent),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Active User",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Workspace Portal",
                                style: TextStyle(color: Colors.white60, fontSize: 11),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ]
              ],
            ),
          ),

          // ================= MAIN APPFRAME CONTENT SHIELD =================
          Expanded(
            child: Column(
              children: [
                // ================= TOP GLOBAL ACTION APPBAR =================
                Container(
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFEBECEF), width: 1.5)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Contextual Dynamic Headline Text
                      Text(
                        _getScreenTitle(currentIndex),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      
                      // Secondary Action Items Toolbar Core
                      Row(
                        children: [
                          // Interactive Quick Signout Action Button Icon Trigger
                          IconButton(
                            onPressed: () => _showLogoutDialog(context),
                            icon: const Icon(Icons.logout_rounded, color: Color(0xFF8F9BB3)),
                            tooltip: "Logout Session",
                            style: IconButton.styleFrom(
                              hoverColor: Colors.red.withOpacity(0.08),
                              highlightColor: Colors.red.withOpacity(0.15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ACTUAL ACTIVE FEATURE VIEW MOUNT HUB
                Expanded(
                  child: widget.navigationShell,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem({
    required IconData icon,
    required String title,
    required int index,
    required int activeIndex,
  }) {
    final bool isSelected = activeIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () => _navigate(index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: isSidebarOpen ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0 ),
                size: 22,
              ),
              if (isSidebarOpen) ...[
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFA0A5B5),
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}