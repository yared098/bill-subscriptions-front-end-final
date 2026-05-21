import 'package:flutter/material.dart';
import '../../../../core/shared_components/settings_drawer/models/setting_section_model.dart';
import '../../../../core/shared_components/settings_drawer/widgets/settings_drawer_panel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Build out the structured menu configuration array
    final List<SettingSection> appSettingsConfig = [
      SettingSection(
        title: 'ACCOUNT',
        items: [
          SettingTileItem(
            icon: Icons.person_outline_rounded,
            title: 'Profile XYZ',
            onTap: () => debugPrint('Navigate to Profile Settings'),
          ),
          SettingTileItem(
            icon: Icons.credit_card_rounded,
            title: 'Payment Methods',
            onTap: () => debugPrint('Navigate to Payment Settings'),
          ),
          SettingTileItem(
            icon: Icons.calendar_today_rounded,
            title: 'Subscriptions',
            onTap: () => debugPrint('Navigate to Subscription List'),
          ),
          SettingTileItem(
            icon: Icons.receipt_long_rounded,
            title: 'Bills',
            onTap: () => debugPrint('Navigate to Invoices/Bills management'),
          ),
          SettingTileItem(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            onTap: () => debugPrint('Navigate to Alert Configurations'),
          ),
          SettingTileItem(
            icon: Icons.shield_outlined,
            title: 'Security',
            onTap: () => debugPrint('Navigate to Security & Multi-factor auth'),
          ),
        ],
      ),
      SettingSection(
        title: 'PREFERENCES',
        items: [
          SettingTileItem(
            icon: Icons.monetization_on_outlined,
            title: 'Currency',
            trailingText: 'ETB',
            onTap: () => debugPrint('Open Currency Picker modal'),
          ),
          SettingTileItem(
            icon: Icons.wb_sunny_outlined,
            title: 'Theme',
            trailingText: 'Light',
            onTap: () => debugPrint('Toggle System Appearance / DarkMode'),
          ),
          SettingTileItem(
            icon: Icons.language_rounded,
            title: 'Language',
            trailingText: 'English',
            onTap: () => debugPrint('Open Language Picker dialog'),
          ),
        ],
      ),
      SettingSection(
        title: 'SUPPORT',
        items: [
          SettingTileItem(
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            onTap: () => debugPrint('Launch FAQ external support link'),
          ),
          SettingTileItem(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () => debugPrint('Render Terms WebView / Markdown view'),
          ),
          SettingTileItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => debugPrint('Render Privacy Safeguards documentation'),
          ),
        ],
      ),
    ];

    // 2. Render the layout view containing the right-side layout sheet
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Muted grey dashboard background
      body: Row(
        children: [
          // Left dynamic placeholder to represent the main content area (Financial Dashboard content)
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Financial Dashboard Main Workspace Grid',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
          
          // Vertical divider frame to anchor the drawer element cleanly
          const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
          
        ],
      ),
    );
  }
}