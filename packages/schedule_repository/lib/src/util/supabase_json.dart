abstract final class SupabaseJson {
  static List<Object?> asList(Object? value) {
    return value is List ? value : const [];
  }

  static Map<String, dynamic> asMap(Object? value) {
    return value is Map ? stringKeyMap(value) : {};
  }

  static Map<String, dynamic> stringKeyMap(Map<dynamic, dynamic> value) {
    return value.map((key, rawValue) => MapEntry(key.toString(), rawValue));
  }

  static List<T> mapRows<T>(
    Object? response,
    T Function(Map<String, dynamic> row) fromJson,
  ) {
    return asList(response)
        .whereType<Map<dynamic, dynamic>>()
        .map((row) => fromJson(stringKeyMap(row)))
        .toList();
  }

  static String dateParam(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
