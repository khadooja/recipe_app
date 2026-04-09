import 'recipe_state.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/recipe_repository.dart';
import 'package:recipe_app/data/datasources/local/recipe_local_datasource.dart';


// lib/presentation/providers/recipe_provider.dart

final recipeDatasourceProvider = Provider<RecipeLocalDatasource>((ref) {
  final datasource = RecipeLocalDatasource();
  return datasource;
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final datasource = ref.watch(recipeDatasourceProvider);
  return RecipeRepository(datasource);
});

final recipeProvider =
    StateNotifierProvider<RecipeNotifier, RecipeState>((ref) {
  // Swap RecipeRepository() for ref.watch(recipeRepositoryProvider)
  // once you wire up a repository provider.
  final repository = ref.watch(recipeRepositoryProvider);
return RecipeNotifier(repository);
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
  void clearError() {
  state = state.copyWith(errorMessage: null);
}
  // ── Add ─────────────────────────────────────────────────────────────────────

  Future<void> addRecipe(Recipe recipe) async {
  state = state.copyWith(status: RecipeStatus.loading);
  try {
    await _repository.addRecipe(recipe);
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
  final previous = state.recipes;
  // Optimistic update
  state = state.copyWith(recipes: _toggledList(state.recipes,id));
  try {
    final updated = state.recipes.firstWhere((r) => r.id == id);
    await _repository.updateRecipe(updated); // ← was placeholder
  } catch (_) {
    state = state.copyWith(recipes: previous); // rollback
  }
}

final favoritesProvider = Provider<List<Recipe>>((ref) {
  return ref.watch(recipeProvider).recipes
      .where((r) => r.isFavorite)
      .toList();
});

  // ── Delete ───────────────────────────────────────────────────────────────────
  Future<void> deleteRecipe(String id) async {
  final previous = state.recipes;
  // Optimistic update
  state = state.copyWith(recipes: state.recipes.where((r) => r.id != id).toList());
  try {
    await _repository.deleteRecipe(id); // ← was placeholder
  } catch (_) {
    state = state.copyWith(recipes: previous); // rollback
  }
}

  // ── Helpers ──────────────────────────────────────────────────────────────────

  /// Returns a new list with the target recipe's isFavorite flipped.
  List<Recipe> _toggledList(List<Recipe> recipes, String id) {
    return recipes.map((r) {
      return r.id == id ? r.copyWith(isFavorite: !r.isFavorite) : r;
    }).toList();
  }

  void _loadAll() {}
}