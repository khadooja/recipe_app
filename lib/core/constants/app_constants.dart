/// Centralized constants for the Recipe App.
///
/// All Hive box names and app-wide defaults live here so they're
/// easy to find and impossible to typo across files.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ── Hive Box Names ──────────────────────────────────────────────
  static const String recipesBox = 'recipes';

  // ── Default Values ──────────────────────────────────────────────
  static const String defaultCategory = 'Uncategorized';
  static const String defaultImagePath = '';

  // ── Category Options ────────────────────────────────────────────
  static const List<String> categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Dessert',
    'Beverage',
    'Uncategorized',
  ];
}
