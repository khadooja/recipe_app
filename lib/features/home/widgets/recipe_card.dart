import 'package:flutter/material.dart';
import '../../../data/models/recipe.dart';

/// ─── Recipe Card ──────────────────────────────────────────────────
///
/// Displays a single recipe in a vertical list.
///
/// Widget tree:
/// ```
/// Card
///   └── InkWell (tap → recipe detail)
///         └── Column
///               ├── _CardImage      (top, fixed-height image with overlay)
///               └── _CardBody       (title + cooking time + favorite chip)
/// ```
///
/// **Usage:**
/// ```dart
/// RecipeCard(
///   recipe: recipe,
///   onTap: () => Navigator.push(...),
///   onFavoriteTap: () => ref.read(recipeProvider.notifier).toggleFavorite(recipe.id),
/// )
/// ```
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias, // image respects rounded corners
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardImage(recipe: recipe, onFavoriteTap: onFavoriteTap),
            _CardBody(recipe: recipe, theme: theme),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────

/// Top section of the card: image with a favorite icon overlay.
class _CardImage extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onFavoriteTap;

  const _CardImage({required this.recipe, this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Recipe image ──────────────────────────────────────
          _buildImage(),

          // ── Gradient overlay for readability ──────────────────
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black26],
              ),
            ),
          ),

          // ── Favorite button (top-right) ───────────────────────
          Positioned(
            top: 8,
            right: 8,
            child: _FavoriteButton(
              isFavorite: recipe.isFavorite,
              onTap: onFavoriteTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (recipe.imageUrl.isEmpty) {
      return _PlaceholderImage();
    }

    // Network image with error fallback
    return Image.network(
      recipe.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _PlaceholderImage(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _PlaceholderImage(isLoading: true);
      },
    );
  }
}

/// Colored placeholder shown when there is no image URL or it fails.
class _PlaceholderImage extends StatelessWidget {
  final bool isLoading;
  const _PlaceholderImage({this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : Icon(
                Icons.restaurant,
                size: 48,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              ),
      ),
    );
  }
}

/// Animated heart button for toggling favorites.
class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  const _FavoriteButton({required this.isFavorite, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isFavorite
              ? Colors.red.withValues(alpha: 0.9)
              : Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

/// Bottom section of the card: title, cooking time.
class _CardBody extends StatelessWidget {
  final Recipe recipe;
  final ThemeData theme;

  const _CardBody({required this.recipe, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ───────────────────────────────────────────
          Text(
            recipe.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // ── Cooking time ─────────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '${recipe.cookingTime} min',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),

              // ── Ingredient count (bonus info) ────────────────
              if (recipe.ingredients.isNotEmpty) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.grocery_outlined,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${recipe.ingredients.length} ingredients',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
