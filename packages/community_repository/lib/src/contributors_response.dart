import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:github/github.dart';

part 'contributors_response.freezed.dart';

@freezed
/// Contributors returned by the configured source repository.
abstract class ContributorsResponse with _$ContributorsResponse {
  /// Creates a contributor response.
  const factory ContributorsResponse({
    required List<Contributor> contributors,
  }) = _ContributorsResponse;
}

@freezed
/// A user reference attached to a Discourse topic.
abstract class DiscourseTopicPoster with _$DiscourseTopicPoster {
  /// Creates a topic-poster reference.
  const factory DiscourseTopicPoster({required int userId}) =
      _DiscourseTopicPoster;
}

@freezed
/// Metadata used to render a Discourse topic preview.
abstract class DiscourseTopic with _$DiscourseTopic {
  /// Creates a topic preview.
  const factory DiscourseTopic({
    required int id,
    required String title,
    required int postsCount,
    required int replyCount,
    required int likeCount,
    required int views,
    required List<DiscourseTopicPoster> posters,
    DateTime? lastPostedAt,
    DateTime? createdAt,
    String? imageUrl,
    String? excerpt,
  }) = _DiscourseTopic;
}

@freezed
/// A Discourse account referenced by topic metadata.
abstract class DiscourseUser with _$DiscourseUser {
  /// Creates a Discourse user.
  const factory DiscourseUser({
    required int id,
    required String username,
    required String avatarTemplate,
  }) = _DiscourseUser;
}

@freezed
/// The top-topic feed and its referenced users.
abstract class TopTopicsResponse with _$TopTopicsResponse {
  /// Creates a top-topic feed.
  const factory TopTopicsResponse({
    required List<DiscourseTopic> topics,
    required List<DiscourseUser> users,
  }) = _TopTopicsResponse;
}

@freezed
/// A rendered post returned by Discourse.
abstract class DiscoursePost with _$DiscoursePost {
  /// Creates a Discourse post.
  const factory DiscoursePost({
    required int id,
    required int topicId,
    required String username,
    required String avatarTemplate,
    required String cooked,
    required DateTime createdAt,
  }) = _DiscoursePost;
}

@freezed
/// A reply in a Discourse topic thread.
abstract class DiscoursePostComment with _$DiscoursePostComment {
  /// Creates a topic reply.
  const factory DiscoursePostComment({
    required int id,
    required String username,
    required String avatarTemplate,
    required String cooked,
    required DateTime createdAt,
    @Default(0) int likeCount,
  }) = _DiscoursePostComment;
}
