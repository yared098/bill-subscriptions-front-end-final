import 'package:flutter/material.dart';
import '../../domain/entities/onboard_entity.dart';

class OnboardPage extends StatelessWidget {
  final OnboardEntity onboardData;

  const OnboardPage({
    super.key,
    required this.onboardData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Main Visual Feature
          Expanded(
            flex: 4,
            child: Image.asset(
              onboardData.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback placeholder with matching brand gradient accents
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_active_outlined,
                      size: 100,
                      color: Colors.teal,
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          // Content Feature Text
          Text(
            onboardData.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A365D), // Rich Brand Midnight Blue
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            onboardData.description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}