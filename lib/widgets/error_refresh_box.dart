import 'package:flutter/material.dart';

class ErrorRefreshBox extends StatelessWidget {
  final String errorMessage;
  final Future<void> Function() onRefresh;
  const ErrorRefreshBox({
    super.key,
    required this.errorMessage,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 0.5, color: theme.colorScheme.outline),
        color: theme.colorScheme.surface.withAlpha(180),
      ),
      child: Column(
        children: [
          Text(
            errorMessage,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          IconButton(onPressed: onRefresh, icon: Icon(Icons.refresh)),
        ],
      ),
    );
  }
}
