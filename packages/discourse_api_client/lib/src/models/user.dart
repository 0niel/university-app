import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.username,
    required this.name,
    required this.avatarTemplate,
    required this.trustLevel,
    this.admin,
    this.moderator,
    this.customFields,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  final int id;
  final String username;
  final String? name;
  @JsonKey(name: 'avatar_template')
  final String avatarTemplate;
  final bool? admin;
  final bool? moderator;
  @JsonKey(name: 'trust_level')
  final int trustLevel;
  @JsonKey(name: 'custom_fields')
  final Map<String, dynamic>? customFields;
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
