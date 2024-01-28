import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contributor.g.dart';

/// {@template contributor}
/// The contributor github model.
/// {@endtemplate}
@JsonSerializable()
class Contributor extends Equatable {
  /// {@macro contributor}
  const Contributor({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.contributions,
  });

  /// Converts a `Map<String, dynamic>` into a [Contributor] instance.
  factory Contributor.fromJson(Map<String, dynamic> json) => _$ContributorFromJson(json);

  /// The contributor's login.
  final String login;

  /// The contributor's avatar url.
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;

  /// The contributor's html url.
  @JsonKey(name: 'html_url')
  final String htmlUrl;

  /// The contributor's contributions.
  final int contributions;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$ContributorToJson(this);

  @override
  List<Object?> get props => [login, avatarUrl, htmlUrl, contributions];
}
