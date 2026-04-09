class _RecipeFormFields extends StatelessWidget {
  const _RecipeFormFields({
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
        _FormField(
          controller: titleController,
          label: 'Title',
          hint: 'e.g. Spaghetti Carbonara',
          validator: _requiredValidator('Title'),
          textInputAction: TextInputAction.next,
        ),
        _FormField(
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
              child: _FormField(
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
              child: _FormField(
                controller: difficultyController,
                label: 'Difficulty',
                hint: 'Easy / Medium / Hard',
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
        _FormField(
          controller: ingredientsController,
          label: 'Ingredients',
          hint: 'One ingredient per line\ne.g. 200g pasta',
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          validator: _requiredValidator('Ingredients'),
        ),
        _FormField(
          controller: stepsController,
          label: 'Steps',
          hint: 'One step per line\ne.g. Boil water',
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          validator: _requiredValidator('Steps'),
        ),
        _FormField(
          controller: imageUrlController,
          label: 'Image URL (optional)',
          hint: 'https://...',
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}