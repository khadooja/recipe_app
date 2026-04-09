import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_app/data/models/recipe.dart';


// lib/data/datasources/recipe_local_datasource.dart


class RecipeLocalDatasource {
  static const String _boxName = 'recipes';

  Box<Recipe> get _box => Hive.box<Recipe>(_boxName);

  // READ
  List<Recipe> getAllRecipes() {
    return _box.values.toList();
  }

  // CREATE
  Future<void> addRecipe(Recipe recipe) async {
    await _box.put(recipe.id, recipe);
  }

  // UPDATE (used by toggleFavorite and future editRecipe)
  Future<void> updateRecipe(Recipe recipe) async {
    await _box.put(recipe.id, recipe);
  }

  // DELETE
  Future<void> deleteRecipe(String id) async {
    await _box.delete(id);
  }
}