import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/src/dates_converter.dart';
import 'package:schedule/src/schedule_part.dart';

part 'unknown_schedule_part.g.dart';

/// {@template unknown_block}
/// Unknown schedule part type.
/// {@endtemplate}
@JsonSerializable()
class UnknownSchedulePart with EquatableMixin implements SchedulePart {
  /// {@macro unknown_block}
  const UnknownSchedulePart({
    this.dates = const [],
    this.type = UnknownSchedulePart.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [UnknownSchedulePart] instance.
  factory UnknownSchedulePart.fromJson(Map<String, dynamic> json) => _$UnknownSchedulePartFromJson(json);

  /// The unknown schedule part type identifier.
  static const identifier = '__unknown__';

  @override
  final String type;

  @override
  @DatesConverter()
  final List<DateTime> dates;

  @override
  Map<String, dynamic> toJson() => _$UnknownSchedulePartToJson(this);

  @override
  List<Object> get props => [type];
}
