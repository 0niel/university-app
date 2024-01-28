import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template dates_converter}
/// Converts a list of [DateTime] to a list of [String] and vice versa.
/// {@endtemplate}
class DatesConverter implements JsonConverter<List<DateTime>, List<dynamic>> {
  /// {@macro dates_converter}
  const DatesConverter();

  @override
  List<DateTime> fromJson(List<dynamic> json) {
    return json.map((e) => DateFormat('dd-MM-yyyy').parse(e as String)).toList();
  }

  @override
  List<dynamic> toJson(List<DateTime> dates) {
    return dates.map((e) => DateFormat('dd-MM-yyyy').format(e)).toList();
  }
}
