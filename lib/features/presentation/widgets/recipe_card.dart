import 'package:flutter/material.dart';
import '../../../data/models/recipe.dart';

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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardImage(
              recipe: recipe,
              onFavoriteTap: onFavoriteTap,
            ),
            _CardBody(recipe: recipe),
          ],
        ),
      ),
    );
  }
}

// ── Image Section (محسّن + نفس تصميمك) ─────────────────────────────

class _CardImage extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onFavoriteTap;

  const _CardImage({
    required this.recipe,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ Hero + Image مفصول
          Hero(
            tag: 'recipe_image_${recipe.id}',
            child: _RecipeImageWrapper(recipe: recipe),
          ),

          // ✅ Gradient overlay (رجعناه 👌)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black26],
              ),
            ),
          ),

          // ✅ زر المفضلة فوق
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
}

// ── Image Wrapper (يحافظ على AspectRatio) ─────────────────────────

class _RecipeImageWrapper extends StatelessWidget {
  final Recipe recipe;

  const _RecipeImageWrapper({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _RecipeImage(imageUrl: recipe.imageUrl),
    );
  }
}

// ── Image Widget (NEW Clean Version) ───────────────────────────────

class _RecipeImage extends StatelessWidget {
  final String? imageUrl;

  const _RecipeImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return const _PlaceholderImage();
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const _PlaceholderImage();
      },
      errorBuilder: (_, __, ___) => const _PlaceholderImage(),
    );
  }
}

// ── Placeholder ───────────────────────────────────────────────────

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ── Favorite Button (محسن) ───────────────────────────────────────

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  const _FavoriteButton({
    required this.isFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Icon(
          isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          key: ValueKey(isFavorite),
          color: isFavorite ? Colors.redAccent : Colors.white,
        ),
      ),
    );
  }
}

// ── Body ─────────────────────────────────────────────────────────

class _CardBody extends StatelessWidget {
  final Recipe recipe;

  const _CardBody({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            '${recipe.cookTimeMinutes} min',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}