import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final VoidCallback onProfile;
  final VoidCallback onPayments;
  final VoidCallback onSubscriptions;
  final VoidCallback onBills;
  final VoidCallback onNotifications;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.onProfile,
    required this.onPayments,
    required this.onSubscriptions,
    required this.onBills,
    required this.onNotifications,
    required this.onSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5F7FB),
      child: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5B67F1),
                    Color(0xFF7B4DFF),
                  ],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person, size: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Finance Manager",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= MENU =================
            _item(Icons.person, "Profile", onProfile),
            _item(Icons.payment, "Payment Methods", onPayments),
            _item(Icons.subscriptions, "Subscriptions", onSubscriptions),
            _item(Icons.receipt_long, "Bills", onBills),
            _item(Icons.notifications, "Notifications", onNotifications),

            const Divider(height: 30),

            _item(Icons.settings, "Settings", onSettings),

            const Spacer(),

            // ================= LOGOUT =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ITEM =================
  Widget _item(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}