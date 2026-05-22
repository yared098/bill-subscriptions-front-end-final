import 'package:flutter/material.dart';

class AppBars {
  static AppBar primary({
    required String title,
    List<Widget>? actions,
  }) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,

      // 🚫 REMOVE BACK BUTTON COMPLETELY
      automaticallyImplyLeading: false,

      centerTitle: true,

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