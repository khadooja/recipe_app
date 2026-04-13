import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Material(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.error_outline_rounded,
                  color: cs.onErrorContainer, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: cs.onErrorContainer,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(Icons.close_rounded,
                    color: cs.onErrorContainer, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}