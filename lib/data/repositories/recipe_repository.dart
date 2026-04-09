import '../models/recipe.dart';
import '../datasources/local/recipe_local_datasource.dart';
/*
/// ─── Recipe Repository ────────────────────────────────────────────
///
/// Sits between the datasource and the Riverpod providers.
///
/// **Why have a repository at all?**
/// - Providers talk to [RecipeRepository], never directly to Hive.
/// - If you add a remote API later, you swap the datasource inside
///   this class — zero changes needed in providers or UI.
/// - Makes unit-testing providers trivial: mock the repository,
///   not the Hive box.
///
/// **Rule:** This class contains NO business logic — it only
/// delegates to the datasource and returns results. Business logic
/// (filtering, sorting, validation) lives in the provider/notifier.
class RecipeRepository {
  final RecipeLocalDatasource _datasource;

  const RecipeRepository(this._datasource);

  // ── Read ───────────────────────────────────────────────────────

  /// Returns all persisted recipes.
  List<Recipe> getAllRecipes() => _datasource.getAll();

  /// Returns a single recipe by [id], or `null` if not found.
  Recipe? getRecipeById(String id) => _datasource.getById(id);

  /// Returns only recipes marked as favorites.
  List<Recipe> getFavorites() => _datasource.getFavorites();

  // ── Write ──────────────────────────────────────────────────────

  /// Persists a new [recipe].
  Future<void> addRecipe(Recipe recipe) => _datasource.addRecipe(recipe);

  /// Replaces the stored recipe that shares [recipe.id].
  Future<void> updateRecipe(Recipe recipe) => _datasource.updateRecipe(recipe);

  /// Removes the recipe with the given [id].
  Future<void> deleteRecipe(String id) => _datasource.deleteRecipe(id);

  /// Flips the `isFavorite` flag for the recipe with the given [id].
  Future<bool> toggleFavorite(String id) => _datasource.toggleFavoriteRecipe(id);
}*/
// lib/data/repositories/recipe_repository.dart



class RecipeRepository {
  final RecipeLocalDatasource _datasource;

  const RecipeRepository(this._datasource);

  List<Recipe> getAllRecipes() => _datasource.getAllRecipes();

  Future<void> addRecipe(Recipe recipe) =>
      _datasource.addRecipe(recipe);

  Future<void> updateRecipe(Recipe recipe) =>
      _datasource.updateRecipe(recipe);

  Future<void> deleteRecipe(String id) =>
      _datasource.deleteRecipe(id);
}
