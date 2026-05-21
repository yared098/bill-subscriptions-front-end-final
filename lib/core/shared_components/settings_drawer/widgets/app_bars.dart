import 'package:flutter/material.dart';

class AppBars {
  static AppBar primary({
    required String title,
    List<Widget>? actions,
    VoidCallback? onBack,
  }) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: Color(0xFF0F172A)),
              onPressed: onBack,
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      actions: actions,
    );
  }
}