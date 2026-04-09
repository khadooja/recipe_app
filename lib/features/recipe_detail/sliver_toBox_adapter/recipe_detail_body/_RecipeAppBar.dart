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
            icon: liveRecipe.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: liveRecipe.isFavorite ? Colors.redAccent : Colors.white,
            onTap: () => ref
                .read(recipeProvider.notifier)
                .toggleFavorite(recipe.id),
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
        background: _AppBarBackground(imageUrl: recipe.imageUrl),
      ),
    );
  }
}