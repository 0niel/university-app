String formatXp(int value) {
  if (value < 1000) return value.toString();
  final text = value.toString();
  final split = text.length - 3;
  return '${text.substring(0, split)} ${text.substring(split)}';
}
