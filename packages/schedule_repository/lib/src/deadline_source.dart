import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'wireValue')
enum DeadlineSource {
  me('me'),
  group('group'),
  prof('prof');

  const DeadlineSource(this.wireValue);

  final String wireValue;

  static DeadlineSource fromWire(String? value) {
    for (final source in values) {
      if (source.wireValue == value) return source;
    }
    return me;
  }
}
