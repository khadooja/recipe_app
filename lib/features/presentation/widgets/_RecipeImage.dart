import 'package:flutter/widgets.dart';
import 'package:recipe_app/core/helpers/image_placeholder.dart';
import 'package:recipe_app/features/presentation/widgets/_ImageLoadingIndicator.dart';

class RecipeImage extends StatelessWidget {
  final String? imageUrl;

  const RecipeImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return const ImagePlaceholder();
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      // Show a shimmer-style container while loading
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return ImageLoadingIndicator(progress: progress);
      },
      errorBuilder: (_, __, ___) => const ImagePlaceholder(),
    );
  }
}