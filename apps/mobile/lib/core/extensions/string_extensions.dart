extension StringX on String {
  bool get isBlank => trim().isEmpty;

  String capitalizeFirst() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String formatPrice() {
    final numeric = replaceAll(RegExp(r'[^\d]'), '');
    if (numeric.isEmpty) return this;
    final value = int.tryParse(numeric) ?? 0;
    final grouped = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return 'TSh $grouped';
  }
}
