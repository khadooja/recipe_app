class _AppBarBackground extends StatelessWidget {
  final String? imageUrl;

  const _AppBarBackground({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'recipe_image_${imageUrl ?? 'placeholder'}',
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                )
              : const _ImagePlaceholder(),
        ),
        // Scrim so the title and icons remain legible at any scroll position
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
              stops: [0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}