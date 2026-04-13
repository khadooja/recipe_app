import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    super.key,
    required this.recipeCount,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFavoritesTap,
  });

  final int recipeCount;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFavoritesTap;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 140,
      floating: true,
      pinned: true,
      snap: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: cs.surface,
      surfaceTintColor: cs.surface,
      actions: [
        IconButton(
          tooltip: 'Favorites',
          onPressed: widget.onFavoritesTap,
          icon: Icon(Icons.favorite_rounded, color: cs.primary),
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 60),
        title: Text(
          'Recipes',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        expandedTitleScale: 1.6,
        background: Padding(
          padding: const EdgeInsets.only(top: 56, left: 20, right: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${widget.recipeCount} recipes ready to cook',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isFocused
                  ? cs.primaryContainer.withOpacity(0.15)
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isFocused ? cs.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: widget.searchController,
              focusNode: _focusNode,
              onChanged: widget.onSearchChanged,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search recipes…',
                hintStyle: TextStyle(color: cs.onSurfaceVariant),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: _isFocused ? cs.primary : cs.onSurfaceVariant,
                ),
                suffixIcon: widget.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          widget.searchController.clear();
                          widget.onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}