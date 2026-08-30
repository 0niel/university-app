import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:test/test.dart';

void main() {
  group('Freezed Discourse models', () {
    test('provide deep value equality and copyWith', () {
      const user = User(
        id: 1,
        username: 'ninja',
        name: 'Ninja',
        avatarTemplate: '/a/{size}.png',
        trustLevel: 2,
        customFields: {'campus': 'V78'},
      );

      final copy = user.copyWith(name: 'Ninja 2');

      expect(User.fromJson(user.toJson()), user);
      expect(copy.name, 'Ninja 2');
      expect(copy.customFields, {'campus': 'V78'});
      expect(copy, isNot(user));
    });

    test('serializes nested top response as JSON maps', () {
      final top = Top.fromJson(_topJson());

      final json = top.toJson();
      final users = json['users'] as List<Object?>;
      final [serializedUser] = users;

      expect(json['users'], isA<List<Object?>>());
      expect(serializedUser, isA<Map<String, dynamic>>());
      expect(json['topic_list'], isA<Map<String, dynamic>>());
      expect(Top.fromJson(json), top);
    });

    test('topic post extracts only the Discourse like action', () {
      final post = TopicPost.fromJson({
        'actions_summary': [
          {'id': 1, 'count': 99},
          {'id': 2, 'count': 4},
        ],
      });

      expect(post.likeCount, 4);
      expect(post.copyWith(likeCount: 5).likeCount, 5);
    });
  });
}

Map<String, dynamic> _topJson() {
  return {
    'users': [
      {
        'id': 1,
        'username': 'ninja',
        'name': null,
        'avatar_template': '/a/{size}.png',
        'trust_level': 2,
      },
    ],
    'topic_list': {
      'can_create_topic': true,
      'for_period': 'monthly',
      'per_page': 50,
      'top_tags': <Object?>[],
      'topics': <Object?>[],
    },
  };
}
