import 'package:recipe_app/data/models/recipe.dart';


// lib/presentation/providers/recipe_state.dart


enum RecipeStatus { initial, loading, success, failure }

class RecipeState {
  final List<Recipe> recipes;
  final RecipeStatus status;
  final String? errorMessage;

  const RecipeState({
    this.recipes = const [],
    this.status = RecipeStatus.initial,
    this.errorMessage,
  });

  // Convenience getters consumed by the UI
  bool get isLoading => status == RecipeStatus.loading;
  bool get isSuccess => status == RecipeStatus.success;
  bool get isFailure => status == RecipeStatus.failure;

  RecipeState copyWith({
    List<Recipe>? recipes,
    RecipeStatus? status,
    String? errorMessage,
  }) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}