import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:recipe_app/features/presentation/widgets/_MetaChip.dart';

class MetaRow extends StatelessWidget {
  final int cookTimeMinutes;
  final int? servings;
  final String? difficulty;

  const MetaRow({
    super.key,
    required this.cookTimeMinutes,
    this.servings,
    this.difficulty, required Recipe recipe,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          MetaChip(
            icon: Icons.timer_outlined,
            label: '$cookTimeMinutes min',
          ),
          if (servings != null) ...[
            VerticalDivider(),
            MetaChip(
              icon: Icons.people_outline_rounded,
              label: '$servings servings',
            ),
          ],
          if (difficulty != null) ...[
            VerticalDivider(),
            MetaChip(
              icon: Icons.bar_chart_rounded,
              label: difficulty!,
            ),
          ],
        ],
      ),
    );
  }
}


