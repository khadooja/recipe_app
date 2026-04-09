import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final int recipeCount;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onFavoritesTap;

  const HomeAppBar({super.key, 
    required this.recipeCount,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFavoritesTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 150,
      floating: true,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,
      actions: [
        IconButton(icon: const Icon(Icons.favorite), onPressed: onFavoritesTap),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recipes',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (recipeCount > 0)
              Text('$recipeCount recipes', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search recipes...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


