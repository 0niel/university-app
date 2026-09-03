import 'package:community_repository/src/contributors_response.dart';
import 'package:discourse_api_client/discourse_api_client.dart' as discourse;
import 'package:equatable/equatable.dart';
import 'package:github/github.dart';

abstract class CommunityFailure with EquatableMixin implements Exception {
  const CommunityFailure(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}

class GetContributorsFailure extends CommunityFailure {
  const GetContributorsFailure(super.error);
}

class GetTopTopicsFailure extends CommunityFailure {
  const GetTopTopicsFailure(super.error);
}

class GetPostFailure extends CommunityFailure {
  const GetPostFailure(super.error);
}

class GetPostCommentsFailure extends CommunityFailure {
  const GetPostCommentsFailure(super.error);
}

class CommunityRepository {
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

  Future<ContributorsResponse> getContributors() async {
    try {
      final contributors = await _github.getContributors();
      return ContributorsResponse(contributors: contributors);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetContributorsFailure(error), stackTrace);
    }
  }

  Future<TopTopicsResponse> getTopTopics({int page = 0}) async {
    try {
      final top = await _discourse.getTop(page: page);
      return TopTopicsResponse(
        hasMore: top.topicList.moreTopicsUrl?.isNotEmpty ?? false,
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

  Future<DiscoursePost> getTopicFirstPost(int topicId) async {
    try {
      final posts = await _discourse.getTopicPosts(topicId);
      final first = posts.firstWhere(
        (p) => p.postNumber == 1,
        orElse: () => posts.first,
      );
      return DiscoursePost(
        id: first.id,
        topicId: topicId,
        username: first.username,
        avatarTemplate: first.avatarTemplate,
        cooked: first.cooked,
        createdAt: DateTime.tryParse(first.createdAt) ?? DateTime.now(),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetPostFailure(error), stackTrace);
    }
  }

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
