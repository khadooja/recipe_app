import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/features/presentation/widgets/recipe_card.dart';
import 'package:recipe_app/features/presentation/screens/recipe_detail_screen.dart';

class RecipeList extends StatelessWidget {
  final WidgetRef ref;
  final List<Recipe> recipes;

  const RecipeList({super.key, required this.ref, required this.recipes});

  void _navigateToDetail(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      sliver: SliverList.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RecipeCard(
              recipe: recipe,
              //onTap: () => _navigateToDetail(context, recipe),
            ),
          );
        },
      ),
    );
  }
}



