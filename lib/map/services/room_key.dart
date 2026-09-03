String roomKey(String name) {
  final upper = name.trim().toUpperCase();
  final buffer = StringBuffer();
  for (final rune in upper.runes) {
    final char = String.fromCharCode(rune);
    if (char == ' ' || char == '-' || char == '_' || char == '.') continue;
    buffer.write(char);
  }
  return buffer.toString();
}

String roomBuilding(String name) {
  final match = RegExp(r'^([А-ЯЁA-Z]+)[\s-]').firstMatch(name.trim());
  return match?.group(1) ?? '';
}
