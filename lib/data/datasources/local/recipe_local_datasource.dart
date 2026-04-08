import 'package:hive_flutter/hive_flutter.dart';
import '../../models/recipe.dart';
import '../../../core/constants/app_constants.dart';

/// ─── Recipe Local Datasource ──────────────────────────────────────
///
/// Single source of truth for all local Recipe persistence.
/// All Hive interactions are contained here — nothing else in the
/// app should open or close the recipes box directly.
///
/// **Usage pattern:**
/// ```dart
/// final ds = RecipeLocalDatasource();
/// await ds.init();            // open the Hive box once at startup
/// final recipes = ds.getAll();
/// ```
///
/// **Key Hive concepts used here:**
/// - `Box<Recipe>` — a typed box; Hive stores Recipe objects directly
///   via the [RecipeAdapter], no manual JSON encoding needed.
/// - Keys — we use `recipe.id` (a UUID string) as the Hive key so
///   looking up a specific recipe by ID is O(1).
/// - `box.values` — returns all stored objects as an `Iterable<Recipe>`.
class RecipeLocalDatasource {
  // ── Internal box reference ─────────────────────────────────────
  // Stored as a late field; guaranteed non-null after `init()`.
  late Box<Recipe> _box;

  // ── Initialisation ─────────────────────────────────────────────

  /// Opens the Hive box.
  ///
  /// Must be called once before any other method — typically in
  /// `main()` or a Riverpod provider's `create` callback.
  /// Safe to call multiple times; Hive returns the already-open box.
  Future<void> init() async {
    _box = await Hive.openBox<Recipe>(AppConstants.recipesBox);
  }

  // ── Read ───────────────────────────────────────────────────────

  /// Returns all stored recipes as an unmodifiable list.
  ///
  /// Converts `box.values` (an `Iterable`) to a `List` so callers
  /// can index, map, and filter without worrying about Hive internals.
  List<Recipe> getAll() {
    return _box.values.toList();
  }

  /// Returns a single recipe by [id], or `null` if not found.
  Recipe? getById(String id) {
    return _box.get(id);
  }

  // ── Write ──────────────────────────────────────────────────────

  /// Persists a new [recipe].
  ///
  /// Uses `recipe.id` as the Hive key — this makes [update] and
  /// [delete] operations O(1) lookups by key.
  Future<void> add(Recipe recipe) async {
    await _box.put(recipe.id, recipe);
  }

  /// Replaces the stored recipe that shares [recipe.id].
  ///
  /// Hive's `put` is an upsert — if the key doesn't exist it inserts,
  /// if it does it replaces. We call this "update" to make intent clear.
  Future<void> update(Recipe recipe) async {
    await _box.put(recipe.id, recipe);
  }

  /// Removes the recipe with the given [id] from storage.
  ///
  /// Silent no-op if the [id] doesn't exist — Hive handles this safely.
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  // ── Domain-specific helpers ────────────────────────────────────

  /// Flips the `isFavorite` flag on the recipe with the given [id].
  ///
  /// Uses `copyWith` on the immutable model rather than mutating it
  /// in place — keeps state predictable and avoids Hive dirty-read issues.
  /// Returns `false` (silent no-op) if the recipe does not exist.
  Future<bool> toggleFavorite(String id) async {
    final recipe = _box.get(id);
    if (recipe == null) return false;

    final updated = recipe.copyWith(isFavorite: !recipe.isFavorite);
    await _box.put(id, updated);
    return true;
  }

  /// Returns only the recipes that are marked as favorites.
  ///
  /// Convenience method — avoids filtering logic leaking into
  /// providers or UI. Ready for the Favorites feature.
  List<Recipe> getFavorites() {
    return _box.values.where((r) => r.isFavorite).toList();
  }

  // ── Cleanup ────────────────────────────────────────────────────

  /// Closes the Hive box.
  ///
  /// Should be called when the datasource is disposed (e.g. when the
  /// Riverpod provider is destroyed). Not strictly required in most
  /// apps, but good practice.
  Future<void> close() async {
    await _box.close();
  }
}
