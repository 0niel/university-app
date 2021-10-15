import 'dart:convert';
import 'package:rtu_mirea_app/domain/entities/forum_member.dart';

class ForumMemberModel extends ForumMember {
  const ForumMemberModel({
    required id,
    required username,
    required name,
    required avatarTemplate,
    required primaryGroupName,
    required flairName,
    required flairUrl,
    required trustLevel,
    required title,
    required lastPostedAt,
    required lastSeenAt,
    required addedAt,
  }) : super(
            id: id,
            username: username,
            name: name,
            avatarTemplate: avatarTemplate,
            primaryGroupName: primaryGroupName,
            flairName: flairName,
            flairUrl: flairUrl,
            trustLevel: trustLevel,
            title: title,
            lastPostedAt: lastPostedAt,
            lastSeenAt: lastSeenAt,
            addedAt: addedAt);

  factory ForumMemberModel.fromRawJson(String str) =>
      ForumMemberModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForumMemberModel.fromJson(Map<String, dynamic> json) =>
      ForumMemberModel(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        avatarTemplate: json["avatar_template"],
        primaryGroupName: json["primary_group_name"],
        flairName: json["flair_name"],
        flairUrl: json["flair_url"],
        trustLevel: json["trust_level"],
        title: json["title"],
        lastPostedAt: json["last_posted_at"] == null
            ? null
            : DateTime.parse(json["last_posted_at"]),
        lastSeenAt: DateTime.parse(json["last_seen_at"]),
        addedAt: DateTime.parse(json["added_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "avatar_template": avatarTemplate,
        "primary_group_name": primaryGroupName,
        "flair_name": flairName,
        "flair_url": flairUrl,
        "trust_level": trustLevel,
        "title": title,
        "last_posted_at":
            lastPostedAt == null ? null : lastPostedAt!.toIso8601String(),
        "last_seen_at": lastSeenAt.toIso8601String(),
        "added_at": addedAt.toIso8601String(),
      };
}
