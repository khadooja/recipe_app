import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final int recipeCount;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onFavoritesTap;

  const HomeAppBar({
    super.key,
    required this.recipeCount,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFavoritesTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 150, // ✅ مناسب بدون overflow
      floating: true,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,

      actions: [
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: onFavoritesTap,
        ),
      ],

      // 🔥 عنوان بسيط عشان ما يصير فراغ أو ضغط
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Text(
          'Recipes',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70), // ✅ زيادة بسيطة تمنع overflow
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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

              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),

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