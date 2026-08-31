DateTime? dateTimeFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

DateTime requiredDateTimeFromJson(Object? value) =>
    dateTimeFromJson(value) ?? .now();

String? dateTimeToJson(DateTime? value) => value?.toUtc().toIso8601String();

String requiredDateTimeToJson(DateTime value) =>
    value.toUtc().toIso8601String();

List<String> stringListFromJson(Object? value) =>
    value is List ? value.whereType<String>().toList() : const [];

List<String> stringListToJson(List<String> value) => value;
