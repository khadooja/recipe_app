class _RecipeDetailBody extends StatelessWidget {
  final RecipeModel recipe;

  const _RecipeDetailBody({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaRow(recipe: recipe),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Ingredients'),
          const SizedBox(height: 12),
          recipe.ingredients.isEmpty
              ? const _EmptySection(message: 'No ingredients listed.')
              : IngredientsList(ingredients: recipe.ingredients),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Steps'),
          const SizedBox(height: 12),
          recipe.steps.isEmpty
              ? const _EmptySection(message: 'No steps listed.')
              : StepsList(steps: recipe.steps),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final RecipeModel recipe;

  const _MetaRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _MetaChip(
            icon: Icons.timer_outlined,
            label: '${recipe.cookTimeMinutes} min',
          ),
          if (recipe.servings != null) ...[
            _MetaDivider(),
            _MetaChip(
              icon: Icons.people_outline_rounded,
              label: '${recipe.servings} servings',
            ),
          ],
          if (recipe.difficulty != null) ...[
            _MetaDivider(),
            _MetaChip(
              icon: Icons.bar_chart_rounded,
              label: recipe.difficulty!,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _MetaDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: Theme.of(context).dividerColor,
      ),
    );
  }
}