import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule.dart';

class SchedulePartsConverter
    implements JsonConverter<List<SchedulePart>, List<Object?>> {
  const SchedulePartsConverter();

  @override
  List<SchedulePart> fromJson(List<Object?> json) => [
    for (final value in json) SchedulePart.fromJson(_jsonObject(value)),
  ];

  @override
  List<Object?> toJson(List<SchedulePart> value) => [
    for (final part in value) part.toJson(),
  ];

  Map<String, dynamic> _jsonObject(Object? value) {
    if (value is! Map<Object?, Object?>) {
      throw const FormatException('Expected a JSON object');
    }

    final result = <String, dynamic>{};
    for (final entry in value.entries) {
      final key = entry.key;
      if (key is! String) {
        throw const FormatException('Expected JSON object keys to be strings');
      }
      result[key] = entry.value;
    }
    return result;
  }
}
