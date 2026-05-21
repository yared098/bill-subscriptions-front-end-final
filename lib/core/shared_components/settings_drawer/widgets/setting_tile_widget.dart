import 'package:flutter/material.dart';
import '../models/setting_section_model.dart';

class SettingTileWidget extends StatelessWidget {
  final SettingTileItem item;

  const SettingTileWidget({
    super.key, 
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(item.icon, color: const Color(0xFF6B7280), size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.w500, 
                  color: Color(0xFF374151),
                ),
              ),
            ),
            if (item.trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  item.trailingText!,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ),
            const Icon(
              Icons.chevron_right_rounded, 
              color: Color(0xFFD1D5DB), 
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}