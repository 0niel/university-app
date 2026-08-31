String ninjaInitials(String name) {
  final letters = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .take(2)
      .map((word) => word[0].toUpperCase())
      .join();
  return letters.isEmpty ? '?' : letters;
}
