import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// A user embedded in a Discourse API response.
@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String username,
    required String? name,
    @JsonKey(name: 'avatar_template') required String avatarTemplate,
    @JsonKey(name: 'trust_level') required int trustLevel,
    bool? admin,
    bool? moderator,
    @JsonKey(name: 'custom_fields') Map<String, dynamic>? customFields,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
