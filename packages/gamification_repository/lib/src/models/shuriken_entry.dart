import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/src/models/json_converters.dart';

part 'shuriken_entry.freezed.dart';
part 'shuriken_entry.g.dart';

@freezed
abstract class ShurikenEntry with _$ShurikenEntry {
  const factory ShurikenEntry({
    @Default('') String title,
    @Default(0) int amount,
    @Default('✨') String emoji,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
  }) = _ShurikenEntry;

  const ShurikenEntry._();

  factory ShurikenEntry.fromJson(Map<String, Object?> json) =>
      _$ShurikenEntryFromJson(json);

  bool get isSpend => amount < 0;
}
