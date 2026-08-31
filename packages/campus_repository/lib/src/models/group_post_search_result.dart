import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_post_search_result.freezed.dart';
part 'group_post_search_result.g.dart';

@freezed
abstract class GroupPostSearchResult with _$GroupPostSearchResult {
  const factory GroupPostSearchResult({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String title,
    @Default('') String body,
    @Default('note') String kind,
    @Default(false) bool isPinned,
    @Default('') String authorName,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
  }) = _GroupPostSearchResult;

  factory GroupPostSearchResult.fromJson(Map<String, Object?> json) =>
      _$GroupPostSearchResultFromJson(json);
}
