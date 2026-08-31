import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preference_entry.freezed.dart';
part 'user_preference_entry.g.dart';

/// A strict, revisioned snapshot from the preference API.
@freezed
abstract class UserPreferenceEntry with _$UserPreferenceEntry {
  /// Creates a preference snapshot.
  const factory UserPreferenceEntry({
    required String key,
    required Map<String, dynamic> value,
    required int revision,
    required DateTime updatedAt,
  }) = _UserPreferenceEntry;

  /// Decodes a preference snapshot.
  factory UserPreferenceEntry.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceEntryFromJson(json);
}
