import 'package:flutter/material.dart';

// Enum to manage our sub-views within the same panel canvas space
enum SettingsView { menu, bills, payments, subscriptions }

class SettingsDrawerPanel extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String planType;
  final String profileImageUrl;
  final VoidCallback onClose;
  final VoidCallback onLogout;

  // Global hooks if you still need external parent reactions
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSecurityTap;
  final VoidCallback? onCurrencyTap;
  final VoidCallback? onThemeTap;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onHelpCenterTap;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const SettingsDrawerPanel({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.planType,
    required this.profileImageUrl,
    required this.onClose,
    required this.onLogout,
    this.onProfileTap,
    this.onNotificationsTap,
    this.onSecurityTap,
    this.onCurrencyTap,
    this.onThemeTap,
    this.onLanguageTap,
    this.onHelpCenterTap,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  State<SettingsDrawerPanel> createState() => _SettingsDrawerPanelState();
}

class _SettingsDrawerPanelState extends State<SettingsDrawerPanel> {
  // Keeps track of which sub-view is actively visible
  SettingsView _currentView = SettingsView.menu;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
      ),
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _buildCurrentViewContent(),
        ),
      ),
    );
  }

  // Router dispatcher targeting specific layout view trees
  Widget _buildCurrentViewContent() {
    switch (_currentView) {
      case SettingsView.bills:
        return _buildSubViewWrapper(title: 'Bills & Invoices', child: _buildBillsView());
      case SettingsView.payments:
        return _buildSubViewWrapper(title: 'Payment Methods', child: _buildPaymentsView());
      case SettingsView.subscriptions:
        return _buildSubViewWrapper(title: 'Subscriptions', child: _buildSubscriptionsView());
      case SettingsView.menu:
      default:
        return _buildMainMenu();
    }
  }

  // Wrapper framework adding back buttons to sub-views cleanly
  Widget _buildSubViewWrapper({required String title, required Widget child}) {
    return Column(
      key: ValueKey(title),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 24.0, 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF4B5563), size: 18),
                onPressed: () => setState(() => _currentView = SettingsView.menu),
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E24),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                onPressed: widget.onClose,
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFFF3F4F6), height: 1),
        Expanded(child: child),
      ],
    );
  }

  // The Root Main Menu structure containing list paths
  Widget _buildMainMenu() {
    return Column(
      key: const ValueKey('main_menu'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header Row
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E24),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                onPressed: widget.onClose,
              ),
            ],
          ),
        ),

        // 2. User Profile Header Block
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFEFF6FF),
                backgroundImage: NetworkImage(widget.profileImageUrl),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      widget.userEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.planType,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Divider(color: Color(0xFFF3F4F6), height: 1),

        // 3. Scrollable Features List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: [
              _buildSectionHeader('ACCOUNT'),
              _buildFeatureTile(Icons.person_outline_rounded, 'Profile', onTap: widget.onProfileTap),
              
              // Internal switching views
              _buildFeatureTile(Icons.credit_card_rounded, 'Payment Methods', onTap: () {
                setState(() => _currentView = SettingsView.payments);
              }),
              _buildFeatureTile(Icons.calendar_today_rounded, 'Subscriptions', onTap: () {
                setState(() => _currentView = SettingsView.subscriptions);
              }),
              _buildFeatureTile(Icons.receipt_long_rounded, 'Bills', onTap: () {
                setState(() => _currentView = SettingsView.bills);
              }),
              
              _buildFeatureTile(Icons.notifications_none_rounded, 'Notifications', onTap: widget.onNotificationsTap),
              _buildFeatureTile(Icons.gpp_good_outlined, 'Security', onTap: widget.onSecurityTap),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Divider(color: Color(0xFFF3F4F6), height: 1),
              ),

              _buildSectionHeader('PREFERENCES'),
              _buildFeatureTile(Icons.monetization_on_outlined, 'Currency', trailingValue: 'ETB', onTap: widget.onCurrencyTap),
              _buildFeatureTile(Icons.timelapse_rounded, 'Theme', trailingValue: 'Light', onTap: widget.onThemeTap),
              _buildFeatureTile(Icons.language_rounded, 'Language', trailingValue: 'English', onTap: widget.onLanguageTap),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Divider(color: Color(0xFFF3F4F6), height: 1),
              ),

              _buildSectionHeader('SUPPORT'),
              _buildFeatureTile(Icons.help_outline_rounded, 'Help Center', onTap: widget.onHelpCenterTap),
              _buildFeatureTile(Icons.description_outlined, 'Terms & Conditions', onTap: widget.onTermsTap),
              _buildFeatureTile(Icons.lock_outline_rounded, 'Privacy Policy', onTap: widget.onPrivacyTap),
            ],
          ),
        ),

        // 4. Sticky Red Bottom Logout Row
        const Divider(color: Color(0xFFF3F4F6), height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 16.0),
          child: InkWell(
            onTap: widget.onLogout,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
               child: Row(
                children: const [
                  Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- SUB VIEW UI LAYOUT RENDERS ---

  Widget _buildBillsView() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildDataCard(
          title: "Invoice #INV-2026-004",
          subtitle: "Due Date: June 05, 2026",
          trailing: "250.00 ETB",
          isUrgent: true,
        ),
        const SizedBox(height: 12),
        _buildDataCard(
          title: "Invoice #INV-2026-003",
          subtitle: "Paid on: May 01, 2026",
          trailing: "180.00 ETB",
          isUrgent: false,
        ),
      ],
    );
  }

  Widget _buildPaymentsView() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildDataCard(
          title: "Telebirr Account",
          subtitle: "Primary Payment Source",
          trailing: "Active",
          icon: Icons.account_balance_wallet_rounded,
        ),
        const SizedBox(height: 12),
        _buildDataCard(
          title: "CBE Birr Wallet",
          subtitle: "Backup Channel",
          trailing: "Linked",
          icon: Icons.phone_android_rounded,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Color(0xFF2563EB)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.add, size: 18, color: Color(0xFF2563EB)),
          label: const Text("Add Payment Method", style: TextStyle(color: Color(0xFF2563EB))),
        )
      ],
    );
  }

  Widget _buildSubscriptionsView() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildDataCard(
          title: "Premium Monthly Pass",
          subtitle: "Renews on: June 14, 2026",
          trailing: "Active",
          isUrgent: false,
        ),
        const SizedBox(height: 12),
        _buildDataCard(
          title: "Cloud Backup Space (50GB)",
          subtitle: "Expired on: May 10, 2026",
          trailing: "Expired",
          isUrgent: true,
        ),
      ],
    );
  }

  // Quick Card UI builder for modular subviews
  Widget _buildDataCard({
    required String title,
    required String subtitle,
    required String trailing,
    bool isUrgent = false,
    IconData icon = Icons.bookmark_outline_rounded,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Icon(icon, color: isUrgent ? const Color(0xFFDC2626) : const Color(0xFF4B5563)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Text(
            trailing,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isUrgent ? const Color(0xFFDC2626) : const Color(0xFF059669),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 14.0, 24.0, 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9CA3AF),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, {String? trailingValue, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF4B5563), size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (trailingValue != null) ...[
                Text(
                  trailingValue,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFD1D5DB), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}