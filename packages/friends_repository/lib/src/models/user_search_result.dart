import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_search_result.freezed.dart';
part 'user_search_result.g.dart';

/// A student search result and its current friendship state.
@freezed
abstract class UserSearchResult with _$UserSearchResult {
  const factory UserSearchResult({
    required String userId,
    @JsonKey(defaultValue: 'Студент') required String fullName,
    String? handle,
    String? group,
    String? friendshipId,
    String? friendshipStatus,
    @Default(false) bool isIncoming,
  }) = _UserSearchResult;

  factory UserSearchResult.fromJson(Map<String, Object?> json) =>
      _$UserSearchResultFromJson(json);
}
