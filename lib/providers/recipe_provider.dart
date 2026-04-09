import 'recipe_state.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/recipe_repository.dart';

// lib/presentation/providers/recipe_provider.dart



final recipeProvider =
    StateNotifierProvider<RecipeNotifier, RecipeState>((ref) {
  // Swap RecipeRepository() for ref.watch(recipeRepositoryProvider)
  // once you wire up a repository provider.
  return RecipeNotifier(RecipeRepository());
});

class RecipeNotifier extends StateNotifier<RecipeState> {
  final RecipeRepository _repository;

  RecipeNotifier(this._repository) : super(const RecipeState()) {
    loadRecipes();
  }

  // ── Load ────────────────────────────────────────────────────────────────────

  Future<void> loadRecipes() async {
    state = state.copyWith(status: RecipeStatus.loading);
    try {
      final recipes = await _repository.getAllRecipes();
      state = state.copyWith(
        recipes: recipes,
        status: RecipeStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        status: RecipeStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  // ── Add ─────────────────────────────────────────────────────────────────────

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _repository.addRecipe(recipe);

      // Append locally — no full reload needed.
      state = state.copyWith(
        recipes: [...state.recipes, recipe],
        status: RecipeStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        status: RecipeStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  // ── Toggle favourite ─────────────────────────────────────────────────────────

  Future<void> toggleFavorite(String id) async {
    // 1. Optimistic local update — UI responds instantly.
    final optimistic = _toggledList(state.recipes, id);
    state = state.copyWith(recipes: optimistic);

    // 2. Persist in background.
    try {
      final updated = optimistic.firstWhere((r) => r.id == id);
      await _repository.updateRecipe(updated);
    } catch (e) {
      // 3. Roll back on failure so the UI stays consistent with storage.
      state = state.copyWith(
        recipes: _toggledList(optimistic, id), // undo
        status: RecipeStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  // ── Delete ───────────────────────────────────────────────────────────────────

  Future<void> deleteRecipe(String id) async {
    final previous = state.recipes;
    state = state.copyWith(
      recipes: previous.where((r) => r.id != id).toList(),
    );

    try {
      await _repository.deleteRecipe(id);
    } catch (e) {
      state = state.copyWith(
        recipes: previous,
        status: RecipeStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  /// Returns a new list with the target recipe's isFavorite flipped.
  List<Recipe> _toggledList(List<Recipe> recipes, String id) {
    return recipes.map((r) {
      return r.id == id ? r.copyWith(isFavorite: !r.isFavorite) : r;
    }).toList();
  }
}