import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/local/recipe_local_datasource.dart';
import '../data/models/recipe.dart';
import '../data/repositories/recipe_repository.dart';
import '../core/utils/id_generator.dart';

// ═══════════════════════════════════════════════════════════════════════
// Infrastructure providers
// ═══════════════════════════════════════════════════════════════════════
//
// Provider hierarchy (each layer depends on the one above it):
//
//   RecipeLocalDatasource  ← owns the Hive box
//         ↓
//   RecipeRepository       ← abstracts the datasource
//         ↓
//   RecipeNotifier         ← owns in-memory state, drives the UI

/// Provides the single, app-wide [RecipeLocalDatasource] instance.
///
/// The datasource's `init()` is called here (inside the provider) using
/// `ref.onDispose` + an async initialiser — but since Hive boxes are
/// opened in `main()` via the same singleton pattern, `Hive.openBox`
/// safely returns the already-open box on the second call.
///
/// This makes the datasource safe to create here without a separate
/// async init step in the provider tree.
final recipeDatasourceProvider = Provider<RecipeLocalDatasource>((ref) {
  final datasource = RecipeLocalDatasource();

  // Open the box (no-op if already open from main.dart).
  // We kick this off but don't await — RecipeNotifier._loadAll()
  // will naturally find the box ready by the time it runs because
  // Flutter's widget build happens after all async work in main() completes.
  datasource.init();

  ref.onDispose(datasource.close);

  return datasource;
});

/// Provides the [RecipeRepository] with its datasource injected.
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final datasource = ref.watch(recipeDatasourceProvider);
  return RecipeRepository(datasource);
});

// ═══════════════════════════════════════════════════════════════════════
// State model
// ═══════════════════════════════════════════════════════════════════════

/// Immutable state snapshot held by [RecipeNotifier].
///
/// Wrapping the list in a dedicated class lets us add extra fields
/// (e.g. `isLoading`, `errorMessage`) without breaking any existing code.
class RecipeState {
  final List<Recipe> recipes;
  final bool isLoading;
  final String? error;

  const RecipeState({
    this.recipes = const [],
    this.isLoading = false,
    this.error,
  });

  RecipeState copyWith({
    List<Recipe>? recipes,
    bool? isLoading,
    String? error,
  }) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
      isLoading: isLoading ?? this.isLoading,
      error: error,                // null clears the error — intentional
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// StateNotifier
// ═══════════════════════════════════════════════════════════════════════

/// Manages the [RecipeState] for the whole app.
///
/// ─── Data flow ───────────────────────────────────────────────────────
///
///   Widget calls notifier method
///     → notifier persists change via repository (Hive)
///     → notifier emits new [RecipeState]
///     → watching widgets rebuild
///
/// ─── Optimistic updates ──────────────────────────────────────────────
///
///   [toggleFavorite] updates in-memory state immediately for instant UI
///   response, then persists to Hive. If persistence fails the state is
///   still consistent — Hive will be synced on the next _loadAll().
///
/// ─── No BuildContext ─────────────────────────────────────────────────
///
///   This class has zero dependency on Flutter widgets or context — it
///   can be unit-tested with a mock repository and no widget tree.
class RecipeNotifier extends StateNotifier<RecipeState> {
  final RecipeRepository _repository;

  RecipeNotifier(this._repository) : super(const RecipeState()) {
    _loadAll();
  }

  // ── Internal ───────────────────────────────────────────────────

  void _loadAll() {
    final loaded = _repository.getAllRecipes();

    // Seed sample data on first ever launch (empty box).
    if (loaded.isEmpty) {
      _seedSampleData();
      return; // _seedSampleData calls _loadAll again after saving
    }

    state = state.copyWith(recipes: loaded, isLoading: false);
  }

  /// Inserts a handful of sample recipes so the UI is never empty
  /// on first run. Called once — subsequent launches have data in Hive.
  Future<void> _seedSampleData() async {
    final samples = [
      Recipe(
        id: IdGenerator.generate(),
        title: 'Classic Margherita Pizza',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/a/a3/Eq_it-na_pizza-margherita_sep2005_sml.jpg',
        ingredients: [
          '2 cups all-purpose flour',
          '1 tsp active dry yeast',
          '3/4 cup warm water',
          '1 tbsp olive oil',
          '1/2 tsp salt',
          '1/2 cup tomato sauce',
          '150g fresh mozzarella',
          'Fresh basil leaves',
        ],
        steps: [
          'Mix flour, yeast, water, oil and salt. Knead for 8 min.',
          'Let dough rest 1 hour until doubled.',
          'Roll out, add sauce, tear mozzarella over top.',
          'Bake at 230°C for 12–15 min.',
          'Top with fresh basil before serving.',
        ],
        cookingTime: 90,
      ),
      Recipe(
        id: IdGenerator.generate(),
        title: 'Creamy Avocado Pasta',
        imageUrl:
            'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=600',
        ingredients: [
          '300g spaghetti',
          '2 ripe avocados',
          '2 cloves garlic',
          'Juice of 1 lemon',
          '2 tbsp olive oil',
          'Salt & pepper',
          'Fresh parsley',
        ],
        steps: [
          'Cook spaghetti according to package directions.',
          'Blend avocados, garlic, lemon juice, and oil until smooth.',
          'Toss hot pasta with avocado sauce.',
          'Season and garnish with parsley.',
        ],
        cookingTime: 20,
      ),
      Recipe(
        id: IdGenerator.generate(),
        title: 'Overnight Oats',
        imageUrl:
            'https://images.unsplash.com/photo-1571748982800-fa51082c2224?w=600',
        ingredients: [
          '1/2 cup rolled oats',
          '1/2 cup milk',
          '1/4 cup Greek yogurt',
          '1 tbsp chia seeds',
          '1 tbsp honey',
          'Fresh berries to serve',
        ],
        steps: [
          'Combine oats, milk, yogurt, chia seeds and honey.',
          'Stir well, cover, and refrigerate overnight.',
          'Top with fresh berries before serving.',
        ],
        cookingTime: 5,
        isFavorite: true,
      ),
      Recipe(
        id: IdGenerator.generate(),
        title: 'Chicken Stir-Fry',
        imageUrl:
            'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=600',
        ingredients: [
          '400g chicken breast, sliced',
          '2 tbsp soy sauce',
          '1 tbsp oyster sauce',
          '1 tsp sesame oil',
          '1 head broccoli',
          '1 red bell pepper',
          '3 cloves garlic',
          '1 tsp ginger',
        ],
        steps: [
          'Marinate chicken in soy sauce for 15 min.',
          'Stir-fry garlic and ginger in a hot wok.',
          'Add chicken and cook until golden.',
          'Add vegetables, stir-fry 3–4 min.',
          'Add oyster sauce and sesame oil, toss.',
        ],
        cookingTime: 25,
      ),
    ];

    for (final recipe in samples) {
      await _repository.addRecipe(recipe);
    }
    _loadAll();
  }

  // ── CRUD ───────────────────────────────────────────────────────

  /// Creates a new recipe, persists it, and refreshes state.
  Future<void> addRecipe({
    required String title,
    String imageUrl = '',
    List<String> ingredients = const [],
    List<String> steps = const [],
    int cookingTime = 0,
  }) async {
    final recipe = Recipe(
      id: IdGenerator.generate(),
      title: title,
      imageUrl: imageUrl,
      ingredients: ingredients,
      steps: steps,
      cookingTime: cookingTime,
    );
    await _repository.addRecipe(recipe);
    _loadAll();
  }

  /// Replaces an existing recipe and refreshes state.
  Future<void> updateRecipe(Recipe recipe) async {
    await _repository.updateRecipe(recipe);
    _loadAll();
  }

  /// Deletes a recipe by [id] and refreshes state.
  Future<void> deleteRecipe(String id) async {
    await _repository.deleteRecipe(id);
    _loadAll();
  }

  // ── Domain logic ───────────────────────────────────────────────

  /// Optimistically toggles `isFavorite` for instant UI feedback,
  /// then persists the change to Hive.
  Future<void> toggleFavorite(String id) async {
    // 1. Instant in-memory flip (UI responds immediately)
    state = state.copyWith(
      recipes: [
        for (final r in state.recipes)
          if (r.id == id) r.copyWith(isFavorite: !r.isFavorite) else r,
      ],
    );
    // 2. Persist to Hive
    await _repository.toggleFavorite(id);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Public providers  — these are what widgets import and watch
// ═══════════════════════════════════════════════════════════════════════

/// Primary provider: full [RecipeState] (recipes + loading + error).
///
/// ```dart
/// // In a ConsumerWidget:
/// final state = ref.watch(recipeProvider);
/// final recipes = state.recipes;
/// final isLoading = state.isLoading;
///
/// // Trigger a mutation:
/// ref.read(recipeProvider.notifier).addRecipe(title: 'Pasta');
/// ref.read(recipeProvider.notifier).deleteRecipe(id);
/// ref.read(recipeProvider.notifier).toggleFavorite(id);
/// ```
final recipeProvider =
    StateNotifierProvider<RecipeNotifier, RecipeState>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return RecipeNotifier(repository);
});

/// Derived provider: reactive list of all recipes.
///
/// ```dart
/// final recipes = ref.watch(recipeListProvider);
/// ```
final recipeListProvider = Provider<List<Recipe>>((ref) {
  return ref.watch(recipeProvider).recipes;
});

/// Derived provider: reactive list of favorite recipes only.
///
/// Used by the Favorites screen — rebuilds only when favorites change.
///
/// ```dart
/// final favorites = ref.watch(favoritesProvider);
/// ```
final favoritesProvider = Provider<List<Recipe>>((ref) {
  return ref.watch(recipeProvider).recipes.where((r) => r.isFavorite).toList();
});
