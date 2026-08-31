import 'package:community_repository/src/contributors_response.dart';
import 'package:discourse_api_client/discourse_api_client.dart' as discourse;
import 'package:equatable/equatable.dart';
import 'package:github/github.dart';

/// Base exception for community data operations.
abstract class CommunityFailure with EquatableMixin implements Exception {
  /// Creates a failure that wraps [error].
  const CommunityFailure(this.error);

  /// The error raised by the underlying client.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// Thrown when contributor retrieval fails.
class GetContributorsFailure extends CommunityFailure {
  /// Creates a contributor retrieval failure.
  const GetContributorsFailure(super.error);
}

/// Thrown when top-topic retrieval fails.
class GetTopTopicsFailure extends CommunityFailure {
  /// Creates a top-topic retrieval failure.
  const GetTopTopicsFailure(super.error);
}

/// Thrown when a post cannot be retrieved.
class GetPostFailure extends CommunityFailure {
  /// Creates a post retrieval failure.
  const GetPostFailure(super.error);
}

/// Thrown when a post's replies cannot be retrieved.
class GetPostCommentsFailure extends CommunityFailure {
  /// Creates a reply retrieval failure.
  const GetPostCommentsFailure(super.error);
}

/// Loads community content from GitHub and Discourse.
class CommunityRepository {
  /// Creates a repository using injected clients or a Discourse base URL.
  CommunityRepository({
    discourse.DiscourseApiClient? discourseClient,
    GithubClient? githubClient,
    String? discourseBaseUrl,
  }) : _discourse =
           discourseClient ??
           discourse.DiscourseApiClient(
             baseUrl: _requireDiscourseBaseUrl(discourseBaseUrl),
           ),
       _github = githubClient ?? GithubClient();

  final discourse.DiscourseApiClient _discourse;
  final GithubClient _github;

  static String _requireDiscourseBaseUrl(String? value) {
    if (value == null || value.isEmpty) {
      throw ArgumentError(
        'Provide discourseBaseUrl when discourseClient is not supplied.',
      );
    }
    return value;
  }

  /// Loads contributors from GitHub.
  Future<ContributorsResponse> getContributors() async {
    try {
      final contributors = await _github.getContributors();
      return ContributorsResponse(contributors: contributors);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetContributorsFailure(error), stackTrace);
    }
  }

  /// Loads the current top-topic feed from Discourse.
  Future<TopTopicsResponse> getTopTopics() async {
    try {
      final top = await _discourse.getTop();
      return TopTopicsResponse(
        topics:
            top.topicList.topics
                .map(
                  (t) => DiscourseTopic(
                    id: t.id,
                    title: t.title,
                    postsCount: t.postsCount,
                    replyCount: t.replyCount,
                    likeCount: t.likeCount,
                    views: t.views,
                    lastPostedAt: DateTime.tryParse(t.lastPostedAt),
                    createdAt: DateTime.tryParse(t.createdAt),
                    imageUrl: t.imageUrl,
                    excerpt: t.excerpt,
                    posters:
                        t.posters
                            .map(
                              (p) => DiscourseTopicPoster(
                                userId: (p['user_id'] as num?)?.toInt() ?? 0,
                              ),
                            )
                            .toList(),
                  ),
                )
                .toList(),
        users:
            top.users
                .map(
                  (u) => DiscourseUser(
                    id: u.id,
                    username: u.username,
                    avatarTemplate: u.avatarTemplate,
                  ),
                )
                .toList(),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetTopTopicsFailure(error), stackTrace);
    }
  }

  /// Loads one rendered Discourse post.
  Future<DiscoursePost> getPost(int id) async {
    try {
      final post = await _discourse.getPost(id);
      return DiscoursePost(
        id: post.id,
        topicId: post.topicId,
        username: post.username,
        avatarTemplate: post.avatarTemplate,
        cooked: post.cooked,
        createdAt: DateTime.tryParse(post.createdAt) ?? DateTime.now(),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetPostFailure(error), stackTrace);
    }
  }

  /// Loads replies for a Discourse topic, excluding its original post.
  Future<List<DiscoursePostComment>> getPostComments({
    required int topicId,
  }) async {
    try {
      final posts = await _discourse.getTopicPosts(topicId);
      return posts
          .where((p) => p.postNumber > 1)
          .map(
            (p) => DiscoursePostComment(
              id: p.id,
              username: p.username,
              avatarTemplate: p.avatarTemplate,
              cooked: p.cooked,
              createdAt: DateTime.tryParse(p.createdAt) ?? DateTime.now(),
              likeCount: p.likeCount,
            ),
          )
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetPostCommentsFailure(error), stackTrace);
    }
  }
}
