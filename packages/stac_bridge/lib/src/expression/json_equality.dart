bool jsonEquals(Object? a, Object? b) {
  if (identical(a, b)) return true;
  if (a is Map<Object?, Object?>) {
    if (b is! Map<Object?, Object?> || a.length != b.length) return false;
    for (final entry in a.entries) {
      if (!b.containsKey(entry.key)) return false;
      if (!jsonEquals(entry.value, b[entry.key])) return false;
    }
    return true;
  }
  if (a is List<Object?>) {
    if (b is! List<Object?> || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!jsonEquals(a[i], b[i])) return false;
    }
    return true;
  }
  if (a is Set<Object?>) {
    if (b is! Set<Object?> || a.length != b.length) return false;
    return a.every(b.contains);
  }
  return a == b;
}
