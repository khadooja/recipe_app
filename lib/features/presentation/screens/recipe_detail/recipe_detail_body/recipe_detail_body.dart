import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:recipe_app/features/presentation/widgets/_EmptySection.dart';
import 'package:recipe_app/features/presentation/widgets/recipe_detail/meta_row.dart';
import 'package:recipe_app/features/presentation/screens/recipe_detail/recipe_detail_body/teps_list.dart';
import 'package:recipe_app/features/presentation/screens/recipe_detail/recipe_detail_body/section_header.dart';
import 'package:recipe_app/features/presentation/screens/recipe_detail/recipe_detail_body/ingredients_list.dart';

class RecipeDetailBody extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailBody({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetaRow(recipe: recipe, cookTimeMinutes: recipe.cookTimeMinutes, servings: recipe.servings, difficulty: recipe.difficulty),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Ingredients'),
          const SizedBox(height: 12),
          recipe.ingredients.isEmpty
              ? const EmptySection(message: 'No ingredients listed.')
              : IngredientsList(ingredients: recipe.ingredients),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Steps'),
          const SizedBox(height: 12),
          recipe.steps.isEmpty
              ? const EmptySection(message: 'No steps listed.')
              : StepsList(steps: recipe.steps),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}





