import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/features/presentation/widgets/_StepRow.dart';
import 'package:recipe_app/features/presentation/widgets/_EmptySection.dart';

class StepsList extends StatelessWidget {
  final List<String> steps;

  const StepsList({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return const EmptySection(message: 'No steps listed.');
    }

    return Column(
      children: List.generate(
        steps.length,
        (index) => StepRow(index: index, step: steps[index]),
      ),
    );
  }
}

