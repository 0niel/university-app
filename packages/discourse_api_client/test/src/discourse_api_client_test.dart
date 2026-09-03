import 'dart:convert';

import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  group('DiscourseApiClient', () {
    test('top topics use a wider period and explicit page', () async {
      final client = DiscourseApiClient(
        baseUrl: 'https://example.com',
        httpClient: MockClient((request) async {
          expect(request.url.queryParameters, {
            'period': 'yearly',
            'page': '2',
          });
          return http.Response.bytes(
            utf8.encode(jsonEncode(_topJson())),
            200,
            headers: const {'content-type': 'application/json; charset=utf-8'},
          );
        }),
      );
      final top = await client.getTop(page: 2);
      expect(top.topicList.moreTopicsUrl, '/top/yearly?page=3');
    });

    test('getTop parses object-shaped tags', () async {
      final client = _clientReturning(_topJson());

      final top = await client.getTop();
      final [topic] = top.topicList.topics;
      final [tag] = topic.tags;
      final [topTag] = top.topicList.topTags;
      final [user] = top.users;

      expect(top.topicList.topics, hasLength(1));
      expect(topic.title, 'Доджинг отчисления');
      expect(tag, isA<Map<String, dynamic>>());
      expect(topTag, isA<Map<String, dynamic>>());
      expect(user.username, 'ninja');
    });

    test('getPost parses a complete post response', () async {
      final client = _clientReturning(_postJson());

      final post = await client.getPost(7);

      expect(post.id, 7);
      expect(post.topicId, 42);
      expect(post.score, 1);
      expect(post.avatarTemplate, '/a/{size}.png');
    });

    test('getTopicPosts parses likes and tolerant defaults', () async {
      final client = _clientReturning({
        'post_stream': {
          'posts': [
            {
              'id': 1,
              'username': 'author',
              'avatar_template': '/a/{size}.png',
              'created_at': '2026-01-01T00:00:00Z',
              'cooked': '<p>First</p>',
              'post_number': 1,
              'actions_summary': [
                {'id': 2, 'count': 3.0},
              ],
            },
            {'id': 2, 'post_number': 2},
          ],
        },
      });

      final posts = await client.getTopicPosts(42);
      final [firstPost, lastPost] = posts;

      expect(posts, hasLength(2));
      expect(firstPost.likeCount, 3);
      expect(lastPost.username, isEmpty);
      expect(lastPost.likeCount, 0);
    });

    test('throws request failure with status and decoded body', () async {
      final client = _clientReturning(
        {
          'errors': ['not found'],
        },
        statusCode: 404,
      );

      await expectLater(
        client.getPost(404),
        throwsA(
          isA<DiscourseApiRequestFailure>()
              .having((failure) => failure.statusCode, 'statusCode', 404)
              .having(
                (failure) => failure.body['errors'],
                'body.errors',
                ['not found'],
              ),
        ),
      );
    });

    test('throws malformed response for invalid JSON', () async {
      final client = DiscourseApiClient(
        baseUrl: 'https://example.com',
        httpClient: MockClient((_) async => http.Response('not-json', 200)),
      );

      await expectLater(
        client.getTop(),
        throwsA(isA<DiscourseApiMalformedResponse>()),
      );
    });

    test('throws malformed response when post stream is absent', () async {
      final client = _clientReturning(const {});

      await expectLater(
        client.getTopicPosts(42),
        throwsA(isA<DiscourseApiMalformedResponse>()),
      );
    });
  });
}

DiscourseApiClient _clientReturning(
  Map<String, dynamic> body, {
  int statusCode = 200,
}) {
  return DiscourseApiClient(
    baseUrl: 'https://example.com',
    httpClient: MockClient(
      (_) async => http.Response.bytes(
        utf8.encode(jsonEncode(body)),
        statusCode,
        headers: const {'content-type': 'application/json; charset=utf-8'},
      ),
    ),
  );
}

Map<String, dynamic> _topJson() {
  return {
    'users': [
      {
        'id': 1,
        'username': 'ninja',
        'name': 'Ninja',
        'avatar_template': '/a/{size}.png',
        'trust_level': 2,
      },
    ],
    'topic_list': {
      'can_create_topic': true,
      'for_period': 'monthly',
      'per_page': 50,
      'more_topics_url': '/top/yearly?page=3',
      'top_tags': [
        {'id': 5, 'name': 'первый-курс', 'slug': 'pervyj-kurs'},
      ],
      'topics': [
        {
          'id': 42,
          'title': 'Доджинг отчисления',
          'posts_count': 10,
          'reply_count': 8,
          'highest_post_number': 10,
          'created_at': '2024-01-01T00:00:00.000Z',
          'last_posted_at': '2024-02-01T00:00:00.000Z',
          'bumped': true,
          'bumped_at': '2024-02-01T00:00:00.000Z',
          'archetype': 'regular',
          'unseen': false,
          'pinned': false,
          'excerpt': 'hi',
          'visible': true,
          'closed': false,
          'archived': false,
          'tags': [
            {'id': 254, 'name': 'отчисление', 'slug': 'otchislenie'},
          ],
          'views': 100,
          'like_count': 5,
          'has_summary': false,
          'category_id': 3,
          'pinned_globally': false,
          'posters': [
            {'user_id': 1, 'extras': 'latest'},
          ],
        },
      ],
    },
  };
}

Map<String, dynamic> _postJson() {
  return {
    'id': 7,
    'username': 'ninja',
    'avatar_template': '/a/{size}.png',
    'created_at': '2026-01-01T00:00:00Z',
    'cooked': '<p>Hello</p>',
    'post_number': 1,
    'post_type': 1,
    'updated_at': '2026-01-01T00:00:00Z',
    'reply_count': 0,
    'reply_to_post_number': null,
    'quote_count': 0,
    'incoming_link_count': 0,
    'reads': 10,
    'readers_count': 5,
    'score': 1,
    'yours': false,
    'topic_id': 42,
    'topic_slug': 'hello',
    'display_username': 'Ninja',
    'version': 1,
    'can_edit': false,
    'can_delete': false,
    'can_recover': false,
    'can_see_hidden_post': false,
    'can_wiki': false,
    'bookmarked': false,
    'raw': 'Hello',
    'actions_summary': <Object?>[],
    'moderator': false,
    'admin': false,
    'staff': false,
    'user_id': 1,
    'hidden': false,
    'trust_level': 2,
    'deleted_at': null,
    'user_deleted': false,
    'can_view_edit_history': false,
    'wiki': false,
    'mentioned_users': <Object?>[],
    'calendar_details': <Object?>[],
    'can_manage_category_expert_posts': false,
    'ratings': <Object?>[],
    'reactions': <Object?>[],
    'reaction_users_count': 0,
    'current_user_used_main_reaction': false,
    'can_accept_answer': false,
    'can_unaccept_answer': false,
    'accepted_answer': false,
    'topic_accepted_answer': false,
  };
}
