import 'package:equatable/equatable.dart';

class ForumMember extends Equatable {
  const ForumMember({
    required this.id,
    required this.username,
    required this.name,
    required this.avatarTemplate,
    required this.primaryGroupName,
    required this.flairName,
    required this.flairUrl,
    required this.trustLevel,
    required this.title,
    required this.lastPostedAt,
    required this.lastSeenAt,
    required this.addedAt,
  });

  final int id;
  final String username;
  final String name;
  final String avatarTemplate;
  final String primaryGroupName;
  final String? flairName;
  final String? flairUrl;
  final int trustLevel;
  final String title;
  final DateTime? lastPostedAt;
  final DateTime lastSeenAt;
  final DateTime addedAt;

  @override
  List<Object?> get props => [
        id,
        username,
        name,
        avatarTemplate,
        primaryGroupName,
        flairName,
        flairUrl,
        trustLevel,
        title,
        lastPostedAt,
        lastSeenAt,
        addedAt
      ];
}
