import '../widgets/recipe_card.dart';
import '../widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/providers/recipe_provider.dart';


// lib/presentation/screens/favorites_screen.dart


class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(recipeProvider).recipes.where((r) => r.isFavorite).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: true,
            title: Text('Favorites'),
          ),
          if (favorites.isEmpty)
            const SliverFillRemaining(
              child: EmptyState(
                icon: Icons.favorite_border,
                title: 'No Favorites Yet', subtitle: 'Tap the heart icon on a recipe to add it here.',  
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RecipeCard(recipe: favorites[index]),
                  childCount: favorites.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}