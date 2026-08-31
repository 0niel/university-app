/// Strips an optional `{{ }}` wrapper from a logic field, so authors may write
/// either a bare expression (`"state.n > 0"`) or a wrapped one.
String stripExpressionBraces(String source) {
  final trimmed = source.trim();
  if (trimmed.startsWith('{{') && trimmed.endsWith('}}')) {
    return trimmed.substring(2, trimmed.length - 2);
  }
  return trimmed;
}

/// JS-like truthiness for condition fields: `false`/`null`/`0`/`''` and empty
/// collections are falsy; everything else is truthy. Shared by the tree
/// resolver (`appIf`/`appForEach`) and the control-flow actions (`runIf`).
bool isTruthy(Object? value) {
  if (value is bool) return value;
  if (value == null) return false;
  if (value is num) return value != 0;
  if (value is String) return value.isNotEmpty;
  if (value is Iterable) return value.isNotEmpty;
  if (value is Map) return value.isNotEmpty;
  return true;
}
