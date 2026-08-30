abstract final class JsonParser {
  static int integer(Object? value) => nullableInteger(value) ?? 0;

  static int? nullableInteger(Object? value) => switch (value) {
    final num number => number.toInt(),
    final String text => int.tryParse(text),
    _ => null,
  };

  static String localDateTime(Object? value) {
    return (DateTime.tryParse(value?.toString() ?? '')?.toLocal() ??
            DateTime.now())
        .toIso8601String();
  }

  static Map<String, int> reactionCounts(Object? value) {
    if (value is! Map) return const {};
    return value.map(
      (key, item) => MapEntry(
        key.toString(),
        item is num ? item.toInt() : (int.tryParse('$item') ?? 0),
      ),
    );
  }
}
