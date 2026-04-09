import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final RecipeModel recipe;

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
        child: _AppBarIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: _AppBarIconButton(
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
          child: _RecipeImage(imageUrl: imageUrl),   // ← shared defensive widget
        ),
        const _ImageScrim(),
      ],
    );
  }
}

// ── Body ───────────────────────────────────────────────────────────────────────

class _RecipeDetailBody extends StatelessWidget {
  final RecipeModel recipe;

  const _RecipeDetailBody({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaRow(recipe: recipe),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Ingredients'),
          const SizedBox(height: 12),
          recipe.ingredients.isEmpty
              ? const _EmptySection(message: 'No ingredients listed.')
              : IngredientsList(ingredients: recipe.ingredients),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Steps'),
          const SizedBox(height: 12),
          recipe.steps.isEmpty
              ? const _EmptySection(message: 'No steps listed.')
              : StepsList(steps: recipe.steps),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── Meta row ───────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final RecipeModel recipe;

  const _MetaRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _MetaChip(
            icon: Icons.timer_outlined,
            label: '${recipe.cookTimeMinutes} min',
          ),
          if (recipe.servings != null) ...[
            _MetaDivider(),
            _MetaChip(
              icon: Icons.people_outline_rounded,
              label: '${recipe.servings} servings',
            ),
          ],
          if (recipe.difficulty != null) ...[
            _MetaDivider(),
            _MetaChip(
              icon: Icons.bar_chart_rounded,
              label: recipe.difficulty!,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _MetaDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: Theme.of(context).dividerColor,
      ),
    );
  }
}

// ── Shared defensive UI ────────────────────────────────────────────────────────

/// Single source of truth for recipe images throughout the app.
/// Handles null URLs, network errors, and loading states consistently.
class _RecipeImage extends StatelessWidget {
  final String? imageUrl;

  const _RecipeImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return const _ImagePlaceholder();
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      // Show a shimmer-style container while loading
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _ImageLoadingIndicator(progress: progress);
      },
      errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
    );
  }
}

class _ImageLoadingIndicator extends StatelessWidget {
  final ImageChunkEvent progress;

  const _ImageLoadingIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = progress.expectedTotalBytes != null
        ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
        : null;

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: CircularProgressIndicator(
          value: percent,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ImageScrim extends StatelessWidget {
  const _ImageScrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black54],
          stops: [0.5, 1.0],
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;

  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
      ),
    );
  }
}

// ── App bar icon button ────────────────────────────────────────────────────────

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _AppBarIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: iconColor ?? Colors.white),
      ),
    );
  }
}