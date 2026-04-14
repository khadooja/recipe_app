import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE0E0E0),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Color(0xFF9E9E9E),
        ),
      ),
    );
  }
}