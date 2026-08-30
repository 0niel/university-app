import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

/// Serializes lesson dates as `dd-MM-yyyy` strings.
///
/// The JSON-side type is `List<dynamic>`: `jsonDecode` (and the Supabase RPC
/// transport) produce untyped lists, and a `List<String>` json type makes the
/// generated code emit a hard `as List<String>` downcast that throws at
/// runtime on every real payload.
class DatesConverter implements JsonConverter<List<DateTime>, List<dynamic>> {
  const DatesConverter();

  static final _format = DateFormat('dd-MM-yyyy');

  @override
  List<DateTime> fromJson(List<dynamic> json) =>
      json.map((value) => _format.parse(value as String)).toList();

  @override
  List<dynamic> toJson(List<DateTime> dates) =>
      dates.map(_format.format).toList();
}
