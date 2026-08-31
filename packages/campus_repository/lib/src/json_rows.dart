List<Map<String, Object?>> decodeJsonRows(
  Object? value, {
  required String context,
}) {
  if (value is! List<Object?>) {
    throw FormatException('$context must be a JSON array');
  }
  return [
    for (final (index, row) in value.indexed)
      decodeJsonRow(row, context: '$context[$index]'),
  ];
}

Map<String, Object?> decodeJsonRow(
  Object? value, {
  required String context,
}) {
  if (value is! Map<Object?, Object?>) {
    throw FormatException('$context must be a JSON object');
  }
  final result = <String, Object?>{};
  for (final MapEntry(:key, value: entryValue) in value.entries) {
    if (key is! String) {
      throw FormatException('$context contains a non-string key');
    }
    result[key] = entryValue;
  }
  return result;
}
