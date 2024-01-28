import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sponsor.g.dart';

/// {@template sponsor}
/// The sponsor model.
/// {@endtemplate}
@JsonSerializable()
class Sponsor extends Equatable {
  /// {@macro Sponsor}
  const Sponsor({
    required this.username,
    required this.email,
    this.about,
    this.avatarUrl,
    this.url,
  });

  /// Converts a `Map<String, dynamic>` into a [Sponsor] instance.
  factory Sponsor.fromJson(Map<String, dynamic> json) => _$SponsorFromJson(json);

  /// The sponsor's username.
  final String username;

  /// The sponsor's avatar url.
  final String? avatarUrl;

  /// The sponsor's about.
  final String? about;

  /// The sponsor's url to external site.
  final String? url;

  /// The sponsor's email for asocciation with the university account.
  final String email;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$SponsorToJson(this);

  @override
  List<Object?> get props => [
        username,
        about,
        email,
        avatarUrl,
        url,
      ];
}
