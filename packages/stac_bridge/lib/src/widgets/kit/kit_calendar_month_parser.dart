export 'stac_app_calendar_month_parser.dart';

String isoDate(DateTime day) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${day.year}-${two(day.month)}-${two(day.day)}';
}

DateTime? dateOf(Object? value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value.length == 7 ? '$value-01' : value);
  return parsed == null
      ? null
      : DateTime(parsed.year, parsed.month, parsed.day);
}
