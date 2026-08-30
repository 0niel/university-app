DateTime? dateTimeFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

String? dateTimeToJson(DateTime? value) => value?.toUtc().toIso8601String();
