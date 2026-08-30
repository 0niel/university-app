import 'package:study_groups_repository/study_groups_repository.dart';
import 'package:test/test.dart';

void main() {
  group('StudyGroup', () {
    test('fromJson maps all fields', () {
      final g = StudyGroup.fromJson(const {
        'id': 'g1',
        'name': 'ИКБО-09-22',
        'emoji': '🚀',
        'description': 'best group',
        'joinCode': 'MNMN6T',
        'isDiscoverable': false,
        'memberCount': 12,
        'createdAt': '2026-01-02T03:04:05Z',
      });

      expect(g.id, 'g1');
      expect(g.name, 'ИКБО-09-22');
      expect(g.emoji, '🚀');
      expect(g.description, 'best group');
      expect(g.joinCode, 'MNMN6T');
      expect(g.isDiscoverable, isFalse);
      expect(g.memberCount, 12);
      expect(g.createdAt, isNotNull);
      expect(g.createdAt?.isUtc, isFalse);
    });

    test('fromJson applies defaults on missing fields', () {
      final g = StudyGroup.fromJson(const {'id': 'g', 'name': 'n'});
      expect(g.emoji, '🎓');
      expect(g.description, '');
      expect(g.joinCode, '');
      expect(g.isDiscoverable, isTrue);
      expect(g.memberCount, 0);
      expect(g.createdAt, isNull);
    });

    test('fromJson treats an invalid date as absent', () {
      final group = StudyGroup.fromJson(const {
        'id': 'g',
        'name': 'n',
        'createdAt': 'not-a-date',
      });

      expect(group.createdAt, isNull);
    });

    test('toJson and copyWith preserve the camelCase contract', () {
      final group = StudyGroup(
        id: 'g1',
        name: 'Initial',
        createdAt: DateTime.utc(2026, 1, 2, 3, 4, 5),
      ).copyWith(name: 'Updated');

      expect(group.toJson(), {
        'id': 'g1',
        'name': 'Updated',
        'emoji': '🎓',
        'description': '',
        'joinCode': '',
        'isDiscoverable': true,
        'memberCount': 0,
        'createdAt': '2026-01-02T03:04:05.000Z',
      });
    });
  });

  group('StudyGroupMember', () {
    test('fromJson maps role and flags', () {
      final m = StudyGroupMember.fromJson(const {
        'userId': 'u1',
        'fullName': 'Иван Иванов',
        'handle': 'ivan',
        'role': 'owner',
        'isOwner': true,
        'isMe': true,
        'isFriend': false,
        'friendshipStatus': null,
      });

      expect(m.userId, 'u1');
      expect(m.fullName, 'Иван Иванов');
      expect(m.handle, 'ivan');
      expect(m.role, 'owner');
      expect(m.isOwner, isTrue);
      expect(m.isMe, isTrue);
      expect(m.isFriend, isFalse);
    });

    test('fromJson defaults to member role', () {
      final m = StudyGroupMember.fromJson(const {
        'userId': 'u',
        'fullName': 'Студент',
      });
      expect(m.role, 'member');
      expect(m.isOwner, isFalse);
      expect(m.fullName, 'Студент');
    });
  });

  group('StudyGroupInvite', () {
    test('fromJson maps fields', () {
      final i = StudyGroupInvite.fromJson(const {
        'id': 'i1',
        'groupId': 'g1',
        'groupName': 'ИКБО-09-22',
        'groupEmoji': '🎓',
        'memberCount': 3,
        'invitedByName': 'Аня',
      });
      expect(i.id, 'i1');
      expect(i.groupId, 'g1');
      expect(i.groupName, 'ИКБО-09-22');
      expect(i.memberCount, 3);
      expect(i.invitedByName, 'Аня');
      expect(StudyGroupInvite.fromJson(i.toJson()), i);
    });
  });

  group('StudyGroupJoinRequest', () {
    test('fromJson maps fields', () {
      final r = StudyGroupJoinRequest.fromJson(const {
        'id': 'r1',
        'userId': 'u2',
        'fullName': 'Пётр',
        'handle': 'petr',
      });
      expect(r.id, 'r1');
      expect(r.userId, 'u2');
      expect(r.fullName, 'Пётр');
      expect(r.handle, 'petr');
    });
  });

  group('StudyGroupSummary', () {
    test('fromJson maps fields', () {
      final s = StudyGroupSummary.fromJson(const {
        'id': 'g1',
        'name': 'ИКБО-09-22',
        'memberCount': 8,
        'ownerName': 'Сергей',
        'hasRequested': true,
      });
      expect(s.id, 'g1');
      expect(s.memberCount, 8);
      expect(s.ownerName, 'Сергей');
      expect(s.hasRequested, isTrue);
      expect(StudyGroupSummary.fromJson(s.toJson()), s);
    });
  });

  group('MyStudyGroup', () {
    test('fromJson with a group parses nested lists', () {
      final my = MyStudyGroup.fromJson(const {
        'hasGroup': true,
        'isOwner': true,
        'group': {'id': 'g1', 'name': 'ИКБО-09-22', 'memberCount': 2},
        'members': [
          {'userId': 'u1', 'fullName': 'A', 'role': 'owner', 'isOwner': true},
          {'userId': 'u2', 'fullName': 'B', 'role': 'member'},
        ],
        'incomingInvites': [
          {
            'id': 'i1',
            'groupId': 'g2',
            'groupName': 'Invite group',
          },
        ],
        'pendingRequests': [
          {'id': 'r1', 'userId': 'u3', 'fullName': 'C'},
        ],
      });

      expect(my.hasGroup, isTrue);
      expect(my.isOwner, isTrue);
      expect(my.group?.name, 'ИКБО-09-22');
      expect(my.members, hasLength(2));
      expect(
        my.members,
        contains(
          isA<StudyGroupMember>().having(
            (member) => member.isOwner,
            'isOwner',
            isTrue,
          ),
        ),
      );
      expect(my.pendingRequests, hasLength(1));
      expect(
        my.incomingInvites,
        contains(
          isA<StudyGroupInvite>().having(
            (invite) => invite.groupId,
            'groupId',
            'g2',
          ),
        ),
      );

      final roundTrip = MyStudyGroup.fromJson(my.toJson());
      expect(roundTrip, my);
    });

    test('fromJson without a group yields hasGroup=false and empties', () {
      final my = MyStudyGroup.fromJson(const {'hasGroup': false});
      expect(my.hasGroup, isFalse);
      expect(my.group, isNull);
      expect(my.members, isEmpty);
      expect(my.incomingInvites, isEmpty);
      expect(my.pendingRequests, isEmpty);
    });

    test('fromJson rejects malformed nested values', () {
      expect(
        () => MyStudyGroup.fromJson(const {
          'members': [null],
        }),
        throwsFormatException,
      );
      expect(
        () => MyStudyGroup.fromJson(const {'incomingInvites': 'not-a-list'}),
        throwsFormatException,
      );
      expect(MyStudyGroup.empty.hasGroup, isFalse);
      expect(MyStudyGroup.empty.members, isEmpty);
    });

    test('fromJson rejects missing required identities', () {
      expect(
        () => StudyGroup.fromJson(const {'name': 'Group'}),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => StudyGroupMember.fromJson(const {'userId': 'u'}),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
