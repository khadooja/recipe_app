import '_FormField.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide FormField;

class RecipeFormFields extends StatelessWidget {
  const RecipeFormFields({super.key, 
    required this.titleController,
    required this.cookTimeController,
    required this.servingsController,
    required this.difficultyController,
    required this.ingredientsController,
    required this.stepsController,
    required this.imageUrlController,
  });

  final TextEditingController titleController;
  final TextEditingController cookTimeController;
  final TextEditingController servingsController;
  final TextEditingController difficultyController;
  final TextEditingController ingredientsController;
  final TextEditingController stepsController;
  final TextEditingController imageUrlController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField(
          controller: titleController,
          label: 'Title',
          hint: 'e.g. Spaghetti Carbonara',
          validator: _requiredValidator('Title'),
          textInputAction: TextInputAction.next,
        ),
        FormField(
          controller: cookTimeController,
          label: 'Cooking Time (minutes)',
          hint: 'e.g. 30',
          keyboardType: TextInputType.number,
          validator: _positiveIntValidator('Cooking time'),
          textInputAction: TextInputAction.next,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FormField(
                controller: servingsController,
                label: 'Servings',
                hint: 'e.g. 4',
                keyboardType: TextInputType.number,
                validator: _optionalIntValidator('Servings'),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FormField(
                controller: difficultyController,
                label: 'Difficulty',
                hint: 'Easy / Medium / Hard',
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
        FormField(
          controller: ingredientsController,
          label: 'Ingredients',
          hint: 'One ingredient per line\ne.g. 200g pasta',
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          validator: _requiredValidator('Ingredients'),
        ),
        FormField(
          controller: stepsController,
          label: 'Steps',
          hint: 'One step per line\ne.g. Boil water',
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          validator: _requiredValidator('Steps'),
        ),
        FormField(
          controller: imageUrlController,
          label: 'Image URL (optional)',
          hint: 'https://...',
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
  
  String? Function(String?)? _requiredValidator(String s) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$s is required.';
      }
      return null;
    };
  }
  
  String? Function(String?)? _optionalIntValidator(String s) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final parsed = int.tryParse(value.trim());
      if (parsed == null || parsed <= 0) {
        return '$s must be a positive number.';
      }
      return null;
    };
  }
  
  String? Function(String?)? _positiveIntValidator(String s) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$s is required.';
      }
      final parsed = int.tryParse(value.trim());
      if (parsed == null || parsed <= 0) {
        return '$s must be a positive number.';
      }
      return null;
    };
  }
}
