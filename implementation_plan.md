# Flutter Recipe App — Project Foundation

Set up a clean, scalable project foundation for a Recipe App before any UI work begins.

---

## 1. Folder Structure

```
lib/
├── main.dart                      # App entry point, provider scope, Hive init
├── app.dart                       # MaterialApp widget (theme, routes)
│
├── core/                          # Shared utilities & constants
│   ├── constants/
│   │   └── app_constants.dart     # Hive box names, default values
│   ├── theme/
│   │   └── app_theme.dart         # ThemeData (for future UI step)
│   └── utils/
│       └── id_generator.dart      # UUID helper
│
├── data/                          # Data layer (models, storage, repositories)
│   ├── models/
│   │   └── recipe.dart            # Recipe data model + Hive TypeAdapter
│   ├── datasources/
│   │   └── local/
│   │       └── recipe_local_datasource.dart  # Hive CRUD operations
│   └── repositories/
│       └── recipe_repository.dart            # Abstracts datasource for providers
│
├── providers/                     # Application state (Riverpod)
│   └── recipe_provider.dart       # StateNotifier + provider for recipe list
│
└── features/                      # Feature-based screens (empty for now)
    ├── home/
    │   └── .gitkeep
    ├── recipe_detail/
    │   └── .gitkeep
    ├── favorites/
    │   └── .gitkeep
    └── search/
        └── .gitkeep
```

**Why this structure?**
- **`data/`** owns models, storage, and repository — nothing else touches Hive directly.
- **`providers/`** owns all Riverpod state — screens just `ref.watch`.
- **`features/`** groups screens by feature so adding Favorites or Search later is just a new folder.
- **`core/`** holds cross-cutting concerns (theme, constants, utils).

---

## 2. Recipe Data Model

```dart
class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final int cookingTimeMinutes;
  final String category;        // e.g. "Breakfast", "Dinner"
  final String imagePath;       // local asset or URL
  final bool isFavorite;        // ready for favorites feature
  final DateTime createdAt;
}
```

- Hive TypeAdapter will be **hand-written** (no build_runner dependency for now; keeps the setup lightweight).
- `isFavorite` is baked in from day one so toggling favorites later is a one-line change.
- `id` uses the `uuid` package for collision-free IDs.

---

## 3. State Management: **Riverpod** (flutter_riverpod)

| Criterion | Provider (pkg) | Riverpod |
|---|---|---|
| Compile-time safety | ❌ runtime errors on missing providers | ✅ compile-time checked |
| Testability | Harder (needs widget tree) | Easy (override in ProviderScope) |
| No `BuildContext` needed | ❌ | ✅ |
| Multiple providers of same type | Needs workarounds | Native |
| Learning curve | Lower | Slightly higher |

**Recommendation → Riverpod** because:
1. The app will grow (favorites, search, filters) — Riverpod avoids the "Provider spaghetti" that comes with deeply nested `ChangeNotifierProvider`s.
2. Testing recipe state without a widget tree is essentially free.
3. `StateNotifier` gives immutable state updates, which makes bugs easier to trace.

Version: `flutter_riverpod: ^2.6.1`

---

## 4. Local Storage: **Hive** (hive + hive_flutter)

| Criterion | SharedPreferences | Hive |
|---|---|---|
| Stores complex objects | ❌ (key-value strings only) | ✅ (TypeAdapters) |
| Performance | OK for small data | Very fast, even for 1000+ recipes |
| Querying/filtering | Manual | Box-level iteration, fast |
| Encryption support | ❌ | ✅ (AES) |

**Recommendation → Hive** because:
1. A `Recipe` has lists of strings (ingredients, steps) — Hive stores that natively; SharedPreferences requires manual JSON serialization.
2. Hive boxes can be opened per-feature (e.g. `recipesBox`, `favoritesBox`), keeping data isolated.
3. Zero platform-channel overhead — pure Dart.

Versions: `hive: ^2.2.3`, `hive_flutter: ^1.1.0`

---

## 5. Dependencies To Add

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  uuid: ^4.5.1
```

No `build_runner` / `hive_generator` — the TypeAdapter will be hand-written to keep the setup simple and dependency-light.

---

## 6. Future-Readiness Hooks

| Future Feature | What we set up now |
|---|---|
| **Favorites** | `isFavorite` field on `Recipe`; `features/favorites/` folder ready |
| **Search** | `category` field for filtering; `features/search/` folder ready |
| **Remote API** | Repository pattern means swapping `LocalDatasource` for `RemoteDatasource` requires zero UI changes |
| **Image upload** | `imagePath` field supports both asset paths and URLs |

---

## Proposed Changes

### Dependencies
#### [MODIFY] [pubspec.yaml](file:///C:/Users/kokha/.gemini/antigravity/scratch/recipe_app/pubspec.yaml)
- Add `flutter_riverpod`, `hive`, `hive_flutter`, `uuid`

---

### Core Layer
#### [NEW] `lib/core/constants/app_constants.dart`
- Hive box names, default values

#### [NEW] `lib/core/theme/app_theme.dart`
- Placeholder ThemeData (will be fleshed out in UI step)

#### [NEW] `lib/core/utils/id_generator.dart`
- Thin wrapper around `uuid` package

---

### Data Layer
#### [NEW] `lib/data/models/recipe.dart`
- `Recipe` class with `copyWith`, `toMap`, `fromMap`
- Hand-written `RecipeAdapter` (Hive TypeAdapter)

#### [NEW] `lib/data/datasources/local/recipe_local_datasource.dart`
- `RecipeLocalDatasource` — open box, CRUD methods

#### [NEW] `lib/data/repositories/recipe_repository.dart`
- `RecipeRepository` class that delegates to datasource

---

### State Layer
#### [NEW] `lib/providers/recipe_provider.dart`
- `RecipeNotifier extends StateNotifier<List<Recipe>>`
- `recipeProvider`, `recipeRepositoryProvider`

---

### App Entry
#### [MODIFY] `lib/main.dart`
- Initialize Hive, register adapter, wrap app in `ProviderScope`

#### [NEW] `lib/app.dart`
- `RecipeApp` widget returning `MaterialApp`

---

### Feature Placeholders
#### [NEW] `lib/features/home/.gitkeep`
#### [NEW] `lib/features/recipe_detail/.gitkeep`
#### [NEW] `lib/features/favorites/.gitkeep`
#### [NEW] `lib/features/search/.gitkeep`

---

## Verification Plan

### Automated
```bash
flutter pub get          # dependencies resolve
flutter analyze          # zero errors / warnings
flutter test             # default widget test still passes (or is updated)
```

### Manual
- Confirm folder structure matches the plan
- Confirm `flutter run` launches without crashes

---

## Open Questions

> [!IMPORTANT]
> 1. **Do you want `build_runner` + `hive_generator`** for auto-generating TypeAdapters? I've defaulted to hand-written adapters to keep things simpler, but code-gen is an option if you prefer.
> 2. **Do you want `freezed` / `json_serializable`** on the Recipe model for JSON support (useful if you plan a REST API later)?
> 3. **Are you happy with the feature folders listed** (`home`, `recipe_detail`, `favorites`, `search`), or do you want to add/rename any?
