import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/features/presentation/widgets/HomeAppBar.dart';
import 'package:recipe_app/features/presentation/widgets/_RecipeList.dart';
import 'package:recipe_app/features/presentation/widgets/empty_state.dart';
import 'package:recipe_app/features/presentation/widgets/_ErrorBanner.dart';
import 'package:recipe_app/features/presentation/widgets/_LoadingView.dart';
import 'package:recipe_app/features/presentation/screens/favorites_screen.dart';
import 'package:recipe_app/features/presentation/screens/add_recipe_screen.dart';

/// ─── Home Screen ──────────────────────────────────────────────────
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Recipe> _filtered(List<Recipe> recipes) {
    if (_searchQuery.isEmpty) return recipes;

    final q = _searchQuery.toLowerCase();
    return recipes.where((r) {
      return r.title.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeProvider);
    final filtered = _filtered(state.recipes);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(recipeProvider.notifier).loadRecipes();
        },
        child: CustomScrollView(
          slivers: [
            HomeAppBar(
              recipeCount: state.recipes.length,
              searchController: _searchController,
              onSearchChanged: (v) => setState(() => _searchQuery = v.trim()),
              onFavoritesTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),

            // ── Error Banner ─────────────────────────────
            if (state.errorMessage != null)
              SliverToBoxAdapter(
                child: ErrorBanner(
                  message: state.errorMessage!,
                  onDismiss: () =>
                      ref.read(recipeProvider.notifier).clearError(),
                ),
              ),

            // ── Body ────────────────────────────────────
            if (state.isLoading)
              const SliverFillRemaining(child: LoadingView())
            else if (state.recipes.isEmpty)
              const SliverFillRemaining(
                child: EmptyState(
                  title: 'No Recipes Yet',
                  subtitle: 'Tap the + button to add your first recipe.', message: '',
                ),
              )
            else if (filtered.isEmpty)
              const SliverFillRemaining(
                child: EmptyState(
                  title: 'No Results',
                  subtitle: 'No recipes match your search.', message: '',
                ),
              )
            else
              RecipeList(ref: ref, recipes: filtered),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddRecipe(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Recipe'),
      ),
    );
  }

  void _navigateToAddRecipe(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddRecipeScreen()));
  }
}

