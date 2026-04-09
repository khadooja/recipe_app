class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isSubmitting,
    required this.onPressed,
  });

  final bool isSubmitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isSubmitting ? null : onPressed,
        child: isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Add Recipe', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}String? Function(String?) _requiredValidator(String fieldName) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  };
}

String? Function(String?) _positiveIntValidator(String fieldName) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return '$fieldName must be a positive number.';
    }
    return null;
  };
}

String? Function(String?) _optionalIntValidator(String fieldName) {
  return (value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return '$fieldName must be a positive number.';
    }
    return null;
  };
}