import 'package:flutter/material.dart';

class ImageLoadingIndicator extends StatelessWidget {
  final ImageChunkEvent progress;

  const ImageLoadingIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = progress.expectedTotalBytes != null
        ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
        : null;

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: CircularProgressIndicator(
          value: percent,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
