import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';

void main() {
  group('Friend', () {
    final json = <String, Object?>{
      'friendshipId': 'friendship-1',
      'userId': 'user-1',
      'fullName': 'Иван Иванов',
      'handle': 'ivan',
      'group': 'ИКБО-01-21',
      'latitude': 55.75,
      'longitude': 37.61,
      'battery': 80,
      'mood': '🙂',
      'isGhost': false,
      'locationUpdatedAt': '2026-06-12T10:00:00.000Z',
    };

    test('round-trips every field', () {
      final friend = Friend.fromJson(json);

      expect(Friend.fromJson(friend.toJson()), friend);
      expect(friend.hasLocation, isTrue);
    });

    test('requires stable identifiers', () {
      expect(() => Friend.fromJson(const {}), throwsA(isA<Exception>()));
    });

    test('copyWith can explicitly clear nullable location fields', () {
      final friend = Friend.fromJson(json);

      final hidden = friend.withoutLocation();

      expect(hidden.latitude, isNull);
      expect(hidden.longitude, isNull);
      expect(hidden.battery, isNull);
      expect(hidden.locationUpdatedAt, isNull);
      expect(hidden.isGhost, isTrue);
      expect(hidden.hasLocation, isFalse);
    });

    test('full equality includes profile fields', () {
      const first = Friend(
        friendshipId: 'friendship-1',
        userId: 'user-1',
        fullName: 'Иван',
      );
      final renamed = first.copyWith(fullName: 'Пётр');

      expect(renamed, isNot(first));
    });
  });

  group('friend graph models', () {
    test('FriendRequest round-trips and compares every field', () {
      const request = FriendRequest(
        friendshipId: 'friendship-1',
        userId: 'user-1',
        fullName: 'Пётр',
        handle: 'petr',
        group: 'ИКБО-01-21',
      );

      expect(FriendRequest.fromJson(request.toJson()), request);
      expect(request.copyWith(fullName: 'Анна'), isNot(request));
    });

    test('UserSearchResult round-trips and compares every field', () {
      const result = UserSearchResult(
        userId: 'user-1',
        fullName: 'Анна',
        handle: 'anna',
        group: 'ИКБО-01-21',
        friendshipId: 'friendship-1',
        friendshipStatus: 'pending',
        isIncoming: true,
      );

      expect(UserSearchResult.fromJson(result.toJson()), result);
      expect(result.copyWith(handle: 'other'), isNot(result));
    });

    test('GroupMember round-trips and compares every field', () {
      const member = GroupMember(
        userId: 'user-1',
        fullName: 'Олег',
        handle: 'oleg',
        isMe: true,
        isFriend: true,
        friendshipStatus: 'accepted',
      );

      expect(GroupMember.fromJson(member.toJson()), member);
      expect(member.copyWith(isMe: false), isNot(member));
    });

    test('GroupRoster round-trips nested members', () {
      const roster = GroupRoster(
        group: 'ИКБО-01-21',
        members: [GroupMember(userId: 'user-1', fullName: 'Олег')],
      );

      expect(GroupRoster.fromJson(roster.toJson()), roster);
      expect(GroupRoster.empty.members, isEmpty);
    });

    test('SuggestedFriend matches the current RPC contract', () {
      const suggestion = SuggestedFriend(
        userId: 'user-1',
        fullName: 'Вера',
        handle: 'vera',
        group: 'ИКБО-02-21',
        mutualCount: 5,
      );

      expect(SuggestedFriend.fromJson(suggestion.toJson()), suggestion);
      expect(suggestion.toJson(), isNot(contains('sameGroup')));
    });
  });

  group('FriendLocationUpdate', () {
    final row = <String, Object?>{
      'user_id': 'user-1',
      'latitude': 55.75,
      'longitude': 37.61,
      'battery': 42,
      'mood': '😎',
      'is_ghost': true,
      'updated_at': '2026-06-12T12:00:00.000Z',
    };

    test('round-trips the snake-case realtime row', () {
      final update = FriendLocationUpdate.fromRow(row);

      expect(FriendLocationUpdate.fromRow(update.toJson()), update);
      expect(update.hasValidCoordinates, isTrue);
    });

    test('rejects missing identity and coordinates', () {
      expect(
        () => FriendLocationUpdate.fromRow(const {}),
        throwsA(isA<Exception>()),
      );
    });

    test('detects non-finite and out-of-range coordinates', () {
      expect(
        const FriendLocationUpdate(
          userId: 'user-1',
          latitude: .nan,
          longitude: 37,
        ).hasValidCoordinates,
        isFalse,
      );
      expect(
        const FriendLocationUpdate(
          userId: 'user-1',
          latitude: 91,
          longitude: 37,
        ).hasValidCoordinates,
        isFalse,
      );
    });

    test('full equality includes privacy and display fields', () {
      final update = FriendLocationUpdate.fromRow(row);

      expect(update.copyWith(isGhost: false), isNot(update));
      expect(update.copyWith(mood: '🙂'), isNot(update));
      expect(update.copyWith(battery: 1), isNot(update));
    });
  });
}
