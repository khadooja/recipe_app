import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/features/presentation/widgets/recipe_card.dart';
import 'package:recipe_app/features/presentation/widgets/empty_state.dart';
import 'package:recipe_app/features/presentation/widgets/home_app_bar.dart';
import 'package:recipe_app/features/presentation/widgets/error_banner.dart';
import 'package:recipe_app/features/presentation/widgets/loading_view.dart';
import 'package:recipe_app/features/presentation/screens/favorites_screen.dart';
import 'package:recipe_app/features/presentation/screens/add_recipe_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final AnimationController _listAnimController;

  @override
  void initState() {
    super.initState();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listAnimController.dispose();
    super.dispose();
  }

  List<Recipe> _filtered(List<Recipe> recipes) {
    if (_searchQuery.isEmpty) return recipes;
    final q = _searchQuery.toLowerCase();
    return recipes.where((r) => r.title.toLowerCase().contains(q)).toList();
  }

  Future<void> _onRefresh() async {
    _listAnimController.reset();
    await ref.read(recipeProvider.notifier).loadRecipes();
    _listAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeProvider);
    final filtered = _filtered(state.recipes);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: Theme.of(context).colorScheme.primary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            HomeAppBar(
              recipeCount: state.recipes.length,
              searchController: _searchController,
              onSearchChanged: (v) => setState(() => _searchQuery = v.trim()),
              onFavoritesTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              ),
            ),
            if (state.errorMessage != null)
              SliverToBoxAdapter(
                child: ErrorBanner(
                  message: state.errorMessage!,
                  onDismiss: () =>
                      ref.read(recipeProvider.notifier).clearError(),
                ),
              ),
            _buildBody(state, filtered),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Recipe'),
        elevation: 4,
      ),
    );
  }

  Widget _buildBody(dynamic state, List<Recipe> filtered) {
    if (state.isLoading) {
      return const SliverFillRemaining(child: LoadingView());
    }
    if (state.recipes.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyState(
          icon: Icons.restaurant_menu_rounded,
          title: 'No Recipes Yet',
          subtitle: 'Tap the + button to add your first recipe.',
        ),
      );
    }
    if (filtered.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: 'No Results Found',
          subtitle: 'Try a different search term.',
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final staggerDelay = (index * 60).clamp(0, 400);
            return AnimatedRecipeCard(
              recipe: filtered[index],
              animationController: _listAnimController,
              delay: Duration(milliseconds: staggerDelay),
            );
          },
          childCount: filtered.length,
        ),
      ),
    );
  }
}