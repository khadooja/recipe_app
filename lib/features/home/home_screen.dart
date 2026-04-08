import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/recipe_provider.dart';
import 'widgets/empty_state.dart';
import 'widgets/recipe_card.dart';

/// ─── Home Screen ──────────────────────────────────────────────────
///
/// Widget tree:
/// ```
/// HomeScreen (ConsumerWidget)
///   └── Scaffold
///         ├── _HomeAppBar        (SliverAppBar with search hint)
///         └── body
///               ├── _LoadingView (while seeding/loading)
///               ├── EmptyState   (when list is empty)
///               └── _RecipeList  (happy path — vertical card list)
/// ```
///
/// **Riverpod usage:**
/// - `ref.watch(recipeProvider)` → rebuilds when state changes
/// - `ref.watch(recipeListProvider)` → derived list, no extra compute
/// - `ref.read(recipeProvider.notifier)` → calls mutations (toggle, delete)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recipeProvider);
    final recipes = state.recipes;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App bar ─────────────────────────────────────────────
          _HomeAppBar(recipeCount: recipes.length),

          // ── Body ────────────────────────────────────────────────
          if (state.isLoading)
            const SliverFillRemaining(child: _LoadingView())
          else if (recipes.isEmpty)
            const SliverFillRemaining(
              child: EmptyState(
                title: 'No Recipes Yet',
                subtitle: 'Tap the + button to add your first recipe.',
              ),
            )
          else
            _RecipeList(ref: ref, recipes: recipes),
        ],
      ),

      // ── FAB: placeholder for Add Recipe screen ─────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: navigate to AddRecipeScreen in the next step
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Recipe — coming next!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Recipe'),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Sub-widgets
// ═══════════════════════════════════════════════════════════════════════

/// Collapsing app bar with the recipe count subtitle.
class _HomeAppBar extends StatelessWidget {
  final int recipeCount;
  const _HomeAppBar({required this.recipeCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recipes',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (recipeCount > 0)
              Text(
                '$recipeCount recipe${recipeCount == 1 ? '' : 's'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Full-list view — a [SliverList] of [RecipeCard] tiles.
class _RecipeList extends StatelessWidget {
  final WidgetRef ref;
  final List recipes;

  const _RecipeList({required this.ref, required this.recipes});

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
              onTap: () {
                // TODO: navigate to RecipeDetailScreen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped: ${recipe.title}')),
                );
              },
              onFavoriteTap: () {
                ref.read(recipeProvider.notifier).toggleFavorite(recipe.id);
              },
            ),
          );
        },
      ),
    );
  }
}

/// Shown while the notifier is seeding or loading data.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
