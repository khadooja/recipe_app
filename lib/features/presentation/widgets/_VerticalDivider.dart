import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(width: 1, color: Theme.of(context).dividerColor),
    );
  }
}