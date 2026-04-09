import 'package:flutter/material.dart';
import 'package:recipe_app/features/presentation/widgets/_StepRow.dart';
// lib/presentation/widgets/recipe_detail/steps_list.dart


class StepsList extends StatelessWidget {
  final List<String> steps;

  const StepsList({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        steps.length,
        (index) => StepRow(index: index, step: steps[index]),
      ),
    );
  }
}

