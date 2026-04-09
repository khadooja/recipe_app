import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:recipe_app/features/presentation/widgets/_MetaChip.dart';
import 'package:recipe_app/features/presentation/widgets/_MetaDivider.dart';

class MetaRow extends StatelessWidget {
  final Recipe recipe;

  const MetaRow({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          MetaChip(
            icon: Icons.timer_outlined,
            label: '${recipe.cookTimeMinutes} min',
          ),
          if (recipe.servings != null) ...[
            MetaDivider(),
            MetaChip(
              icon: Icons.people_outline_rounded,
              label: '${recipe.servings} servings',
            ),
          ],
          if (recipe.difficulty != null) ...[
            MetaDivider(),
            MetaChip(
              icon: Icons.bar_chart_rounded,
              label: recipe.difficulty!,
            ),
          ],
        ],
      ),
    );
  }
}