import 'package:hive/hive.dart';

/// ─── Recipe Model ─────────────────────────────────────────────────
///
/// Core data class representing a single recipe.
///
/// **Field reference:**
/// | Field         | Type           | Purpose                                      |
/// |---------------|----------------|----------------------------------------------|
/// | `id`          | `String`       | Unique identifier (UUID v4)                  |
/// | `title`       | `String`       | Display name of the recipe                   |
/// | `imageUrl`    | `String`       | URL or local asset path for the recipe image |
/// | `ingredients` | `List<String>` | Raw ingredient lines ("2 cups flour")        |
/// | `steps`       | `List<String>` | Ordered preparation instructions             |
/// | `cookingTime` | `int`          | Total cooking time in minutes                |
/// | `isFavorite`  | `bool`         | Whether the user marked this as a favorite   |
///
/// **Design decisions:**
/// - Immutable fields with a `copyWith` method — makes state updates
///   predictable and works well with Riverpod's StateNotifier.
/// - `toMap` / `fromMap` provided for easy JSON interop if a REST API
///   is added later.
/// - Hive TypeAdapter is hand-written below to avoid build_runner.
class Recipe {
  final String id;
  final String title;
  final String? imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final bool isFavorite;
  final int cookTimeMinutes;
  final int? servings;
  final String? difficulty;
  final String? category;
  final String? description;
  final String? imagePath;

  const Recipe({
    required this.id,
    required this.title,
    this.imageUrl = '',
    this.ingredients = const [],
    this.steps = const [],
    this.isFavorite = false,
    this.cookTimeMinutes = 0,
    this.servings,
    this.difficulty,
    this.category,
    this.description,
    this.imagePath,
  });

  // ── Copy With ─────────────────────────────────────────────────────
  /// Returns a new [Recipe] with only the specified fields overridden.
  /// Used for toggling favorites, editing fields, etc.
  Recipe copyWith({
    String? id,
    String? title,
    String? imageUrl,
    List<String>? ingredients,
    List<String>? steps,
    int? cookingTime,
    bool? isFavorite,
    int? cookTimeMinutes,
    int? servings,
    String? difficulty,
    String? category,
    String? description,
    String? imagePath,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      isFavorite: isFavorite ?? this.isFavorite,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  // ── Serialization ─────────────────────────────────────────────────
  /// Converts to a plain `Map` — useful for JSON / API payloads.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'isFavorite': isFavorite,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'category': category,
      'description': description,
      'imagePath': imagePath,
    };
  }

  /// Creates a [Recipe] from a plain `Map`.
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as String,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String? ?? '',
      ingredients: List<String>.from(map['ingredients'] as List? ?? []),
      steps: List<String>.from(map['steps'] as List? ?? []),
      isFavorite: map['isFavorite'] as bool? ?? false,
      cookTimeMinutes: map['cookTimeMinutes'] as int? ?? 0,
      servings: map['servings'] as int?,
      difficulty: map['difficulty'] as String?,
      category: map['category'] as String? ?? '',
      description: map['description'] as String?,
      imagePath: map['imagePath'] as String?,
    );
  }

  // ── Equality & Debugging ──────────────────────────────────────────
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Recipe(id: $id, title: $title)';
}

// ═══════════════════════════════════════════════════════════════════════
// Hive TypeAdapter — hand-written (no code generation)
// ═══════════════════════════════════════════════════════════════════════
//
// **How Hive adapters work:**
//  1. Each field gets a numeric index (0, 1, 2, …).
//  2. `write()` serializes fields in order by index.
//  3. `read()` deserializes them in the same order.
//  4. `typeId` must be unique across ALL adapters in the app.
//     We use 0 for Recipe — the first and primary model.
//
// **Adding a field later:**
//  - Give it the next available index (e.g. 7).
//  - Read it with a fallback default so existing data still loads.
//  - NEVER reorder or reuse old indices — that corrupts stored data.
// ═══════════════════════════════════════════════════════════════════════
class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }

    return Recipe(
      id: fields[0] as String,
      title: fields[1] as String,
      imageUrl: fields[2] as String? ?? '',
      ingredients: (fields[3] as List?)?.cast<String>() ?? [],
      steps: (fields[4] as List?)?.cast<String>() ?? [],
      cookTimeMinutes: fields[5] as int? ?? 0,
      isFavorite: fields[6] as bool? ?? false,
      servings: fields[7] as int?,
      difficulty: fields[8] as String?,
      category: fields[9] as String? ?? '',
      description: fields[10] as String?,
      imagePath: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.ingredients)
      ..writeByte(4)
      ..write(obj.steps)
      ..writeByte(5)
      ..write(obj.cookTimeMinutes)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.servings)
      ..writeByte(8)
      ..write(obj.difficulty)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.imagePath);
  }
}
