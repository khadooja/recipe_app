import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/core/helpers/image_placeholder.dart';

class AppBarBackground extends StatelessWidget {
  final String? imageUrl;

  const AppBarBackground({super.key, this.imageUrl});

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
                  errorBuilder: (_, __, ___) => const ImagePlaceholder(),
                )
              : const ImagePlaceholder(),
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