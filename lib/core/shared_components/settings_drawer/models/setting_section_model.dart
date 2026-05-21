import 'package:flutter/material.dart';

class SettingTileItem {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  SettingTileItem({
    required this.icon,
    required this.title,
    this.trailingText,
    this.onTap,
  });
}

class SettingSection {
  final String title;
  final List<SettingTileItem> items;

  SettingSection({
    required this.title,
    required this.items,
  });
}