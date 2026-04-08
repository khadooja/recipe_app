import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/recipe.dart';

/// App entry point.
///
/// Startup sequence:
///   1. Init Flutter binding (required before any platform calls)
///   2. Init Hive + open the recipes box
///   3. Register the RecipeAdapter (must happen before any box is opened)
///   4. Wrap the widget tree in ProviderScope (Riverpod requirement)
///   5. Run the app
Future<void> main() async {
  // 1. Ensure Flutter engine is ready before calling native code.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Hive and set the storage directory.
  //    hive_flutter's `initFlutter()` automatically picks the correct
  //    platform-specific path (Documents on Windows, Library on iOS, etc.)
  await Hive.initFlutter();

  // 3. Register the hand-written TypeAdapter for Recipe objects.
  //    Must be registered once, and BEFORE any box is opened.
  //    Guard with `isAdapterRegistered` to survive hot restarts.
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(RecipeAdapter());
  }

  // 4. ProviderScope is the root of the Riverpod provider tree.
  //    Every provider in the app is scoped to this widget.
  runApp(const ProviderScope(child: RecipeApp()));
}
