import 'package:freezed_annotation/freezed_annotation.dart';

part 'contributor.freezed.dart';
part 'contributor.g.dart';

@freezed
/// A contributor returned by GitHub's contributors endpoint.
abstract class Contributor with _$Contributor {
  /// Creates a contributor data transfer object.
  const factory Contributor({
    required String login,
    @JsonKey(name: 'avatar_url') required String avatarUrl,
    @JsonKey(name: 'html_url') required String htmlUrl,
    required int contributions,
  }) = _Contributor;

  /// Deserializes a contributor from GitHub API JSON.
  factory Contributor.fromJson(Map<String, dynamic> json) =>
      _$ContributorFromJson(json);
}
