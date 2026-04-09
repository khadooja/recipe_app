import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/core/helpers/app_barIcon_button.dart';
import 'package:recipe_app/features/presentation/widgets/_ImageScrim.dart';
import 'package:recipe_app/features/presentation/widgets/_RecipeImage.dart';
import 'package:recipe_app/features/presentation/widgets/_EmptySection.dart';
import 'package:recipe_app/features/presentation/widgets/recipe_detail/meta_row.dart';
import 'package:recipe_app/features/presentation/widgets/recipe_detail/steps_list.dart';
import 'package:recipe_app/features/presentation/screens/recipe_detail/recipe_detail_body/section_header.dart';
import 'package:recipe_app/features/presentation/screens/recipe_detail/recipe_detail_body/ingredients_list.dart';

// lib/presentation/screens/recipe_detail_screen.dart



class RecipeDetailScreen extends ConsumerWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Always resolve from live state — reflects changes from any screen.
    final liveRecipe = ref.watch(recipeProvider).recipes.firstWhere(
          (r) => r.id == recipe.id,
          orElse: () => recipe,
        );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _RecipeAppBar(recipe: liveRecipe),
          SliverToBoxAdapter(
            child: _RecipeDetailBody(recipe: liveRecipe),
          ),
        ],
      ),
    );
  }
}

// ── App bar ────────────────────────────────────────────────────────────────────

class _RecipeAppBar extends ConsumerWidget {
  final Recipe recipe;

  const _RecipeAppBar({required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: AppBarIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: AppBarIconButton(
            icon: recipe.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: recipe.isFavorite ? Colors.redAccent : Colors.white,
            onTap: () =>
                ref.read(recipeProvider.notifier).toggleFavorite(recipe.id),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          recipe.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                shadows: const [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        background: _AppBarBackground(
          imageUrl: recipe.imageUrl,
          recipeId: recipe.id,
        ),
      ),
    );
  }
}

// ── Hero image background ──────────────────────────────────────────────────────

class _AppBarBackground extends StatelessWidget {
  final String? imageUrl;
  final String recipeId;

  const _AppBarBackground({
    required this.imageUrl,
    required this.recipeId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'recipe_image_$recipeId',
          child: RecipeImage(imageUrl: imageUrl),   // ← shared defensive widget
        ),
        const ImageScrim(),
      ],
    );
  }
}

// ── Body ───────────────────────────────────────────────────────────────────────

class _RecipeDetailBody extends StatelessWidget {
  final Recipe recipe;

  const _RecipeDetailBody({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetaRow(recipe: recipe, cookTimeMinutes: recipe.cookTimeMinutes),
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
