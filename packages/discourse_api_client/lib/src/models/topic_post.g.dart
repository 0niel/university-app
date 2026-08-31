// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TopicPost _$TopicPostFromJson(Map<String, dynamic> json) => _TopicPost(
  id: (json['id'] as num?)?.toInt() ?? 0,
  username: json['username'] as String? ?? '',
  avatarTemplate: json['avatar_template'] as String? ?? '',
  createdAt: json['created_at'] as String? ?? '',
  cooked: json['cooked'] as String? ?? '',
  postNumber: (json['post_number'] as num?)?.toInt() ?? 0,
  likeCount: _likeCountFromActions(json['actions_summary']),
);
