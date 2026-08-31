String stringOrEmpty(Object? value) => value is String ? value : '';

String? stringOrNull(Object? value) => value is String ? value : null;

bool boolOrFalse(Object? value) => value is bool && value;

List<String> stringListOrEmpty(Object? value) {
  return value is List<Object?> ? value.whereType<String>().toList() : const [];
}

List<Map<String, Object?>> mapListOrEmpty(Object? value) {
  if (value is! List<Object?>) return const [];
  return value.whereType<Map<Object?, Object?>>().map((rawMap) {
    final map = <String, Object?>{};
    for (final rawEntry in rawMap.entries) {
      final key = rawEntry.key;
      if (key is String) map[key] = rawEntry.value;
    }
    return map;
  }).toList();
}

int intOrZero(Object? value) => value is num ? value.toInt() : 0;
