import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/features/presentation/widgets/_SubmitButton.dart';
import 'package:recipe_app/features/presentation/widgets/_RecipeFormFields.dart';
// lib/presentation/screens/add_recipe_screen.dart

class AddRecipeScreen extends ConsumerStatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  ConsumerState<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _difficultyController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final cookTimeText = _cookTimeController.text.trim();

    if (cookTimeText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cook time required')));
      return;
    }

    final recipe = Recipe(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),

      cookTimeMinutes: int.parse(cookTimeText),

      servings: int.tryParse(_servingsController.text.trim()),

      difficulty: _difficultyController.text.trim().isEmpty
          ? null
          : _difficultyController.text.trim(),

      ingredients: _parseLines(_ingredientsController.text),
      steps: _parseLines(_stepsController.text),

      // ✅ FIX المهم
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),

      isFavorite: false,
    );

    await ref.read(recipeProvider.notifier).addRecipe(recipe);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe added!'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pop();
  }

  /// Splits a multiline textarea into a trimmed, non-empty list.
  List<String> _parseLines(String raw) =>
      raw.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              RecipeFormFields(
                titleController: _titleController,
                cookTimeController: _cookTimeController,
                servingsController: _servingsController,
                difficultyController: _difficultyController,
                ingredientsController: _ingredientsController,
                stepsController: _stepsController,
                imageUrlController: _imageUrlController,
              ),
              const SizedBox(height: 32),
              SubmitButton(
                isSubmitting: _isSubmitting,
                onPressed: () => _submit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
