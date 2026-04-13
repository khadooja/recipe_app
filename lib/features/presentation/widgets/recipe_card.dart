import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../../data/models/recipe.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
/*
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
}*/

// ── Fallback image map by category ──────────────────────────────────
const _categoryImages = <String, String>{
  'Breakfast':
      'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=600&q=80',
  'Lunch':
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80',
  'Dinner':
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80',
  'Dessert':
      'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=600&q=80',
  'Snack':
      'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=600&q=80',
};

const _defaultImage =
    'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=600&q=80';

String _resolveImage(Recipe recipe) {
  if (recipe.imagePath.isNotEmpty) return recipe.imagePath;
  return _categoryImages[recipe.category] ?? _defaultImage;
}

// ── Animated wrapper ─────────────────────────────────────────────────
class AnimatedRecipeCard extends StatelessWidget {
  const AnimatedRecipeCard({
    super.key,
    required this.recipe,
    required this.animationController,
    required this.delay,
  });

  final Recipe recipe;
  final AnimationController animationController;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        (delay.inMilliseconds / 600).clamp(0.0, 1.0),
        1.0,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) => FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      ),
      child: RecipeCard(recipe: recipe),
    );
  }
}

// ── The card itself ───────────────────────────────────────────────────
class RecipeCard extends ConsumerWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: () {/* navigate to detail */},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cs.outlineVariant.withOpacity(0.5),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              color: cs.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ImageSection(recipe: recipe),
                _BodySection(recipe: recipe, ref: ref),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Image section ────────────────────────────────────────────────────
class _ImageSection extends StatelessWidget {
  const _ImageSection({required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'recipe_image_${recipe.id}',
            child: Image.network(
              _resolveImage(recipe),
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
              errorBuilder: (_, __, ___) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 40,
                ),
              ),
            ),
          ),
          // gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.45),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),
          // category badge
          Positioned(
            top: 10,
            left: 10,
            child: _CategoryBadge(category: recipe.category),
          ),
          // cook time chip
          Positioned(
            bottom: 10,
            left: 12,
            child: Row(
              children: [
                _InfoChip(
                  icon: Icons.schedule_rounded,
                  label: '${recipe.cookingTimeMinutes} min',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: cs.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Body section ─────────────────────────────────────────────────────
class _BodySection extends StatelessWidget {
  const _BodySection({required this.recipe, required this.ref});
  final Recipe recipe;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  recipe.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _FavoriteButton(recipe: recipe, ref: ref),
            ],
          ),
          if (recipe.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              recipe.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          _MetaRow(recipe: recipe),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontSize: 12,
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );

    return Row(
      children: [
        Icon(Icons.people_outline_rounded, size: 14, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Text('${recipe.servings ?? 2} servings', style: style),
        const SizedBox(width: 14),
        Icon(Icons.local_fire_department_outlined,
            size: 14, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(recipe.category, style: style),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            recipe.difficulty ?? 'Easy',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Favorite button ───────────────────────────────────────────────────
class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({required this.recipe, required this.ref});
  final Recipe recipe;
  final WidgetRef ref;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.8,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _tap() async {
    await _ctrl.reverse();
    widget.ref.read(recipeProvider.notifier).toggleFavorite(widget.recipe.id);
    await _ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: _tap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.recipe.isFavorite
                ? cs.errorContainer
                : cs.surfaceContainerHighest,
          ),
          child: Icon(
            widget.recipe.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            size: 18,
            color: widget.recipe.isFavorite
                ? cs.error
                : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
