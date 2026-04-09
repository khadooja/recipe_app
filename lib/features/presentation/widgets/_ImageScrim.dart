import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ImageScrim extends StatelessWidget {
  const ImageScrim({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black54],
          stops: [0.5, 1.0],
        ),
      ),
    );
  }
}
