import 'package:flutter/material.dart';

import '../../../widgets/glass_panel.dart';

/// A compact detail card for session metrics (HR, pace, elevation).
class SessionDetailCard extends StatelessWidget {
  const SessionDetailCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassPanel(
      borderRadius: 12,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: theme.textTheme.headlineMedium,
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: ' $unit',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
