import 'package:flutter/material.dart';

class LabelBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const LabelBox({super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 0.5, color: theme.colorScheme.outlineVariant),
          color: color,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyLarge),
            Text(value, style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}