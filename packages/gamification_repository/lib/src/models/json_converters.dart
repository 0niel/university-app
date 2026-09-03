DateTime? dateTimeFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

String? dateTimeToJson(DateTime? value) => value?.toUtc().toIso8601String();

DateTime dateOnlyFromJson(Object? value) =>
    value is String ? DateTime.parse(value) : DateTime(1970);

String dateOnlyToJson(DateTime value) =>
    value.toIso8601String().split('T').first;
