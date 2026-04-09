import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/core/helpers/app_barIcon_button.dart';
import 'package:recipe_app/features/presentation/screens/recipe_detail/recipe_detail_body/_AppBarBackground.dart';

class RecipeAppBar extends ConsumerWidget {
  final Recipe recipe;

  const RecipeAppBar({super.key, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // ✅ نجيب أحدث state من Riverpod
    final state = ref.watch(recipeProvider);

    // ✅ نجيب النسخة المحدثة من الريسبية
    final liveRecipe = state.recipes.firstWhere(
      (r) => r.id == recipe.id,
      orElse: () => recipe,
    );

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,

      // ── Back button ─────────────────────────────
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: AppBarIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),

      // ── Favorite button ─────────────────────────
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: AppBarIconButton(
            icon: liveRecipe.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor:
                liveRecipe.isFavorite ? Colors.redAccent : Colors.white,
            onTap: () => ref
                .read(recipeProvider.notifier)
                .toggleFavorite(recipe.id),
          ),
        ),
      ],

      // ── Flexible Space ─────────────────────────
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

        background: AppBarBackground(imageUrl: recipe.imageUrl),
      ),
    );
  }
}