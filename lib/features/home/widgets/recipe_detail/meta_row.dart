class MetaRow extends StatelessWidget {
  final int cookTimeMinutes;
  final int? servings;
  final String? difficulty;

  const MetaRow({
    super.key,
    required this.cookTimeMinutes,
    this.servings,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _MetaChip(
            icon: Icons.timer_outlined,
            label: '$cookTimeMinutes min',
          ),
          if (servings != null) ...[
            _VerticalDivider(),
            _MetaChip(
              icon: Icons.people_outline_rounded,
              label: '$servings servings',
            ),
          ],
          if (difficulty != null) ...[
            _VerticalDivider(),
            _MetaChip(
              icon: Icons.bar_chart_rounded,
              label: difficulty!,
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

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(width: 1, color: Theme.of(context).dividerColor),
    );
  }
}