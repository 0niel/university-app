DateTime? dateTimeFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

String? dateTimeToJson(DateTime? value) => value?.toUtc().toIso8601String();

DateTime dateOnlyFromJson(Object? value) =>
    value is String ? DateTime.parse(value) : .new(1970);

String dateOnlyToJson(DateTime value) {
  final isoDate = value.toIso8601String();
  return isoDate.substring(0, isoDate.indexOf('T'));
}
