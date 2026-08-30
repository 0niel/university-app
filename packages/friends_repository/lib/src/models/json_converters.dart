DateTime? optionalDateTimeFromJson(Object? value) => switch (value) {
  final DateTime dateTime => dateTime,
  final String rawValue => DateTime.tryParse(rawValue),
  _ => null,
};

String? optionalDateTimeToJson(DateTime? value) => value?.toIso8601String();
