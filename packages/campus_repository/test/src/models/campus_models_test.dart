import 'package:campus_repository/campus_repository.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:test/test.dart';

void main() {
  group('Search models', () {
    test('parse camelCase payloads and tolerate missing values', () {
      final trending = TrendingSearch.fromJson(const {
        'query': 'матан',
        'count': 4.0,
      });
      final result = GroupPostSearchResult.fromJson(const {
        'id': 'post-1',
        'title': 'Конспект',
        'authorName': 'Анна',
        'createdAt': '2026-01-02T03:04:05Z',
      });

      expect(trending, const TrendingSearch(query: 'матан', count: 4));
      expect(result.authorName, 'Анна');
      expect(result.createdAt?.toUtc().year, 2026);
      expect(GroupPostSearchResult.fromJson(const {}).kind, 'note');
    });

    test('round-trip without changing the wire names', () {
      const trending = TrendingSearch(query: 'физика', count: 3);
      const result = GroupPostSearchResult(
        id: 'post-1',
        title: 'Лекция',
        authorName: 'Иван',
      );

      expect(TrendingSearch.fromJson(trending.toJson()), trending);
      expect(GroupPostSearchResult.fromJson(result.toJson()), result);
      expect(result.toJson(), containsPair('authorName', 'Иван'));
    });
  });

  group('GroupLink', () {
    test('fromJson maps all fields', () {
      final link = GroupLink.fromJson(const <String, dynamic>{
        'id': 'l1',
        'title': 'Chat',
        'url': 'https://t.me/x',
        'emoji': '💬',
        'kind': 'telegram',
        'addedBy': 'user-1',
        'isMine': true,
      });

      expect(link.id, 'l1');
      expect(link.title, 'Chat');
      expect(link.url, 'https://t.me/x');
      expect(link.emoji, '💬');
      expect(link.kind, 'telegram');
      expect(link.addedBy, 'user-1');
      expect(link.isMine, isTrue);
    });

    test('fromJson rejects missing required fields', () {
      expect(
        () => GroupLink.fromJson(const <String, dynamic>{}),
        throwsFormatException,
      );
      expect(
        () => GroupLink.fromJson(const {
          'id': 'link-1',
          'title': 'Chat',
          'url': ' ',
        }),
        throwsFormatException,
      );
    });

    test('isTelegram is true only for telegram kind', () {
      const base = {'id': 'link-1', 'title': 'Chat', 'url': 'https://x.dev'};
      expect(
        GroupLink.fromJson({...base, 'kind': 'telegram'}).isTelegram,
        isTrue,
      );
      expect(GroupLink.fromJson({...base, 'kind': 'link'}).isTelegram, isFalse);
      expect(GroupLink.fromJson(base).isTelegram, isFalse);
    });

    test('safeUri accepts HTTPS and rejects spoofed Telegram hosts', () {
      expect(
        GroupLinkAddress.parse('t.me/group', telegramOnly: true).toString(),
        'https://t.me/group',
      );
      expect(
        GroupLinkAddress.tryParse(
          'https://example.com/?next=t.me/group',
          telegramOnly: true,
        ),
        isNull,
      );
      expect(GroupLinkAddress.tryParse('javascript:alert(1)'), isNull);
      expect(GroupLinkAddress.tryParse('https://user@example.com'), isNull);
    });
  });

  group('GroupAnnouncement', () {
    test('fromJson maps all fields including createdAt', () {
      final a = GroupAnnouncement.fromJson(const <String, dynamic>{
        'id': 'a1',
        'title': 'Notice',
        'body': 'Body text',
        'authorName': 'Староста',
        'createdAt': '2026-01-02T03:04:05Z',
        'isMine': true,
      });

      expect(a.id, 'a1');
      expect(a.title, 'Notice');
      expect(a.body, 'Body text');
      expect(a.authorName, 'Староста');
      expect(a.createdAt, isNotNull);
      expect(a.isMine, isTrue);
    });

    test('fromJson defaults; createdAt null when absent', () {
      final a = GroupAnnouncement.fromJson(const <String, dynamic>{});

      expect(a.id, '');
      expect(a.title, '');
      expect(a.body, '');
      expect(a.authorName, '');
      expect(a.createdAt, isNull);
      expect(a.isMine, isFalse);
    });
  });

  group('GroupNote', () {
    test('fromJson maps all fields', () {
      final n = GroupNote.fromJson(const <String, dynamic>{
        'id': 'n1',
        'title': 'Lecture notes',
        'body': 'content',
        'authorName': 'Ivan',
        'createdAt': '2026-01-02T03:04:05Z',
        'isPinned': true,
        'isMine': true,
        'likes': 7,
        'likedByMe': true,
      });

      expect(n.id, 'n1');
      expect(n.title, 'Lecture notes');
      expect(n.body, 'content');
      expect(n.authorName, 'Ivan');
      expect(n.createdAt, isNotNull);
      expect(n.isPinned, isTrue);
      expect(n.isMine, isTrue);
      expect(n.likes, 7);
      expect(n.likedByMe, isTrue);
    });

    test('fromJson defaults', () {
      final n = GroupNote.fromJson(const <String, dynamic>{});

      expect(n.id, '');
      expect(n.title, '');
      expect(n.body, '');
      expect(n.authorName, '');
      expect(n.createdAt, isNull);
      expect(n.isPinned, isFalse);
      expect(n.isMine, isFalse);
      expect(n.likes, 0);
      expect(n.likedByMe, isFalse);
    });

    test('likes coerces from double-like num', () {
      final n = GroupNote.fromJson(const <String, dynamic>{'likes': 3.0});
      expect(n.likes, 3);
    });
  });

  group('GroupBirthday', () {
    test('fromJson maps fields and parses date', () {
      final b = GroupBirthday.fromJson(const <String, dynamic>{
        'name': 'Anna',
        'date': '2026-06-20T00:00:00Z',
        'isMe': true,
      });

      expect(b.name, 'Anna');
      expect(b.isMe, isTrue);
      expect(b.date.toUtc().year, 2026);
      expect(b.date.toUtc().month, 6);
      expect(b.date.toUtc().day, 20);
    });

    test('fromJson defaults to now when date missing', () {
      final before = DateTime.now();
      final b = GroupBirthday.fromJson(const <String, dynamic>{});
      final after = DateTime.now();

      expect(b.name, '');
      expect(b.isMe, isFalse);
      expect(
        b.date.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(b.date.isBefore(after.add(const Duration(seconds: 1))), isTrue);
    });

    test('daysLeft is 0 for today', () {
      final now = DateTime.now();
      final b = GroupBirthday(name: 'X', date: now);
      expect(b.daysLeft, 0);
    });

    test('daysLeft counts whole days to a future date', () {
      final target = DateTime.now().add(const Duration(days: 5));
      final b = GroupBirthday(name: 'X', date: target);
      expect(b.daysLeft, 5);
    });
  });

  group('GroupSpace', () {
    test('fromJson maps nested lists and objects', () {
      final space = GroupSpace.fromJson(const <String, dynamic>{
        'group': 'БСБО-01-22',
        'memberCount': 3,
        'memberNames': ['A', 'B', 'C'],
        'links': [
          {
            'id': 'l1',
            'title': 'Telegram',
            'url': 'https://t.me/group',
            'kind': 'telegram',
          },
          {
            'id': 'l2',
            'title': 'Portal',
            'url': 'https://example.com',
            'kind': 'link',
          },
        ],
        'announcement': {'id': 'a1', 'title': 'Hi'},
        'notes': [
          {'id': 'n1'},
        ],
        'birthdays': [
          {'name': 'Anna', 'date': '2026-06-20T00:00:00Z'},
        ],
      });

      expect(space.group, 'БСБО-01-22');
      expect(space.memberCount, 3);
      expect(space.memberNames, ['A', 'B', 'C']);
      expect(space.links, hasLength(2));
      expect(space.announcement?.id, 'a1');
      expect(space.notes, hasLength(1));
      expect(space.birthdays, hasLength(1));
    });

    test('fromJson defaults to empty collections and null objects', () {
      final space = GroupSpace.fromJson(const <String, dynamic>{});

      expect(space.group, isNull);
      expect(space.memberCount, 0);
      expect(space.memberNames, isEmpty);
      expect(space.links, isEmpty);
      expect(space.announcement, isNull);
      expect(space.notes, isEmpty);
      expect(space.birthdays, isEmpty);
    });

    test('wrong nested container types fail', () {
      for (final json in const [
        <String, Object?>{'links': 'not-a-list'},
        <String, Object?>{'notes': 42},
        <String, Object?>{'birthdays': null},
        <String, Object?>{'announcement': 'not-an-object'},
      ]) {
        expect(() => GroupSpace.fromJson(json), throwsFormatException);
      }
    });

    test('invalid nested rows fail instead of being silently dropped', () {
      expect(
        () => GroupSpace.fromJson(const <String, dynamic>{
          'links': ['not-an-object'],
        }),
        throwsFormatException,
      );
    });

    test('telegram getter returns first telegram link only', () {
      final space = GroupSpace.fromJson(const <String, dynamic>{
        'links': [
          {'id': 'l1', 'title': 'One', 'url': 'https://one.dev'},
          {
            'id': 'l2',
            'title': 'Two',
            'url': 'https://t.me/two',
            'kind': 'telegram',
          },
          {
            'id': 'l3',
            'title': 'Three',
            'url': 'https://t.me/three',
            'kind': 'telegram',
          },
        ],
      });
      expect(space.telegram?.id, 'l2');
    });

    test('telegram getter is null when no telegram links', () {
      final space = GroupSpace.fromJson(const <String, dynamic>{
        'links': [
          {'id': 'l1', 'title': 'One', 'url': 'https://one.dev'},
        ],
      });
      expect(space.telegram, isNull);
    });

    test('plainLinks excludes telegram links', () {
      final space = GroupSpace.fromJson(const <String, dynamic>{
        'links': [
          {'id': 'l1', 'title': 'One', 'url': 'https://one.dev'},
          {
            'id': 'l2',
            'title': 'Two',
            'url': 'https://t.me/two',
            'kind': 'telegram',
          },
          {'id': 'l3', 'title': 'Three', 'url': 'https://three.dev'},
        ],
      });
      expect(space.plainLinks.map((l) => l.id), ['l1', 'l3']);
    });

    test('empty constant has no data', () {
      expect(GroupSpace.empty.group, isNull);
      expect(GroupSpace.empty.links, isEmpty);
    });
  });

  group('CampusEvent', () {
    test('fromJson maps all fields', () {
      final e = CampusEvent.fromJson(const <String, dynamic>{
        'id': 'e1',
        'title': 'Party',
        'startsAt': '2026-01-02T03:04:05Z',
        'description': 'desc',
        'emoji': '🥳',
        'category': 'fun',
        'place': 'Hall',
        'goingCount': 12,
        'isGoing': true,
        'isMine': true,
        'goingNames': ['A', 'B'],
      });

      expect(e.id, 'e1');
      expect(e.title, 'Party');
      expect(e.startsAt.toUtc().year, 2026);
      expect(e.description, 'desc');
      expect(e.emoji, '🥳');
      expect(e.category, 'fun');
      expect(e.place, 'Hall');
      expect(e.goingCount, 12);
      expect(e.isGoing, isTrue);
      expect(e.isMine, isTrue);
      expect(e.goingNames, ['A', 'B']);
    });

    test('fromJson defaults; startsAt defaults to now-ish', () {
      final before = DateTime.now();
      final e = CampusEvent.fromJson(const <String, dynamic>{});
      final after = DateTime.now();

      expect(e.id, '');
      expect(e.title, '');
      expect(e.description, '');
      expect(e.emoji, '🎉');
      expect(e.category, 'other');
      expect(e.place, '');
      expect(e.goingCount, 0);
      expect(e.isGoing, isFalse);
      expect(e.isMine, isFalse);
      expect(e.goingNames, isEmpty);
      expect(
        e.startsAt.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        e.startsAt.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('copyWith overrides goingCount/isGoing and keeps the rest', () {
      final e = CampusEvent.fromJson(const <String, dynamic>{
        'id': 'e1',
        'title': 'Party',
        'goingCount': 1,
        'isMine': true,
      });
      final updated = e.copyWith(goingCount: 5, isGoing: true);

      expect(updated.id, 'e1');
      expect(updated.title, 'Party');
      expect(updated.goingCount, 5);
      expect(updated.isGoing, isTrue);
      expect(updated.isMine, isTrue);
    });
  });

  group('MarketListing', () {
    test('fromJson maps all fields', () {
      final m = MarketListing.fromJson(const <String, dynamic>{
        'id': 'm1',
        'title': 'Laptop',
        'price': 5000,
        'description': 'desc',
        'category': 'electronics',
        'emoji': '💻',
        'isSold': true,
        'createdAt': '2026-01-02T03:04:05Z',
        'isMine': true,
        'sellerName': 'Ivan',
        'showContact': true,
        'sellerHandle': 'ivan_dev',
      });

      expect(m.id, 'm1');
      expect(m.title, 'Laptop');
      expect(m.price, 5000);
      expect(m.description, 'desc');
      expect(m.category, 'electronics');
      expect(m.emoji, '💻');
      expect(m.isSold, isTrue);
      expect(m.createdAt, isNotNull);
      expect(m.isMine, isTrue);
      expect(m.sellerName, 'Ivan');
      expect(m.showContact, isTrue);
      expect(m.sellerHandle, 'ivan_dev');
    });

    test('fromJson defaults optional fields', () {
      final m = MarketListing.fromJson(const <String, dynamic>{
        'id': 'm1',
        'title': 'Laptop',
        'price': 5000,
      });
      expect(m.description, '');
      expect(m.category, 'other');
      expect(m.emoji, '📦');
      expect(m.isSold, isFalse);
      expect(m.createdAt, isNull);
      expect(m.isMine, isFalse);
      expect(m.sellerName, '');
      expect(m.showContact, isFalse);
      expect(m.sellerHandle, isNull);
    });

    test('fromJson rejects missing identity and price fields', () {
      expect(
        () => MarketListing.fromJson(const <String, dynamic>{}),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('isFree is true only when price is 0', () {
      expect(
        MarketListing.fromJson(
          const {'id': 'm1', 'title': 'Gift', 'price': 0},
        ).isFree,
        isTrue,
      );
      expect(
        MarketListing.fromJson(
          const {'id': 'm2', 'title': 'Book', 'price': 100},
        ).isFree,
        isFalse,
      );
    });
  });

  group('Mentor', () {
    test('fromJson maps all fields', () {
      final m = Mentor.fromJson(const <String, dynamic>{
        'userId': 'u1',
        'fullName': 'Anna P',
        'topics': ['math', 'physics'],
        'bio': 'bio',
        'sessions': 4,
        'level': 'pro',
        'formats': ['online'],
        'price': 200,
        'isMe': true,
        'course': 3,
        'group': 'БСБО-01',
        'handle': '@anna',
      });

      expect(m.userId, 'u1');
      expect(m.fullName, 'Anna P');
      expect(m.topics, ['math', 'physics']);
      expect(m.bio, 'bio');
      expect(m.sessions, 4);
      expect(m.level, 'pro');
      expect(m.formats, ['online']);
      expect(m.price, 200);
      expect(m.isMe, isTrue);
      expect(m.course, 3);
      expect(m.group, 'БСБО-01');
      expect(m.handle, '@anna');
    });

    test('rejects a payload without mentor identity', () {
      expect(
        () => Mentor.fromJson(const <String, dynamic>{}),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });
  });

  group('MentorRequest', () {
    test('fromJson maps all fields', () {
      final r = MentorRequest.fromJson(const <String, dynamic>{
        'id': 'r1',
        'mentorUserId': 'mentor-1',
        'requesterId': 'requester-1',
        'topic': 'algebra',
        'whenSlot': 'tomorrow',
        'message': 'help',
        'requesterName': 'Bob',
        'requesterHandle': '@bob',
        'createdAt': '2026-01-02T03:04:05Z',
      });

      expect(r.id, 'r1');
      expect(r.topic, 'algebra');
      expect(r.whenSlot, MentorWhenSlot.tomorrow);
      expect(r.message, 'help');
      expect(r.requesterName, 'Bob');
      expect(r.requesterHandle, '@bob');
      expect(r.createdAt, isNotNull);
    });

    test('rejects missing identity and invalid wire values', () {
      expect(
        () => MentorRequest.fromJson(const <String, dynamic>{}),
        throwsA(isA<CheckedFromJsonException>()),
      );
      expect(
        () => MentorRequest.fromJson(const {
          'id': 'r1',
          'mentorUserId': 'mentor-1',
          'requesterId': 'requester-1',
          'whenSlot': 'today',
        }),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });
  });

  group('Team', () {
    test('fromJson maps all fields', () {
      final t = Team.fromJson(const <String, dynamic>{
        'id': 't1',
        'title': 'Team A',
        'eventName': 'Hack',
        'description': 'desc',
        'neededRoles': ['backend'],
        'capacity': 4,
        'kind': 'project',
        'deadlineAt': '2026-02-01T00:00:00Z',
        'isBoosted': true,
        'createdAt': '2026-01-02T03:04:05Z',
        'isMine': true,
        'isMember': true,
        'hasApplied': true,
        'myApplicationId': 'application-1',
        'status': 'closed',
        'applicationsCount': 2,
        'memberCount': 3,
        'memberNames': ['A', 'B', 'C'],
      });

      expect(t.id, 't1');
      expect(t.title, 'Team A');
      expect(t.eventName, 'Hack');
      expect(t.description, 'desc');
      expect(t.neededRoles, ['backend']);
      expect(t.capacity, 4);
      expect(t.kind, 'project');
      expect(t.deadlineAt, isNotNull);
      expect(t.isBoosted, isTrue);
      expect(t.createdAt, isNotNull);
      expect(t.isMine, isTrue);
      expect(t.isMember, isTrue);
      expect(t.hasApplied, isTrue);
      expect(t.myApplicationId, 'application-1');
      expect(t.status, TeamStatus.closed);
      expect(t.applicationsCount, 2);
      expect(t.memberCount, 3);
      expect(t.memberNames, ['A', 'B', 'C']);
    });

    test('fromJson defaults optional fields', () {
      final t = Team.fromJson(const <String, dynamic>{
        'id': 't1',
        'title': 'Team A',
      });
      expect(t.eventName, '');
      expect(t.description, '');
      expect(t.neededRoles, isEmpty);
      expect(t.capacity, 5);
      expect(t.kind, 'hackathon');
      expect(t.deadlineAt, isNull);
      expect(t.isBoosted, isFalse);
      expect(t.createdAt, isNull);
      expect(t.isMine, isFalse);
      expect(t.isMember, isFalse);
      expect(t.hasApplied, isFalse);
      expect(t.myApplicationId, isNull);
      expect(t.status, TeamStatus.open);
      expect(t.applicationsCount, 0);
      expect(t.memberCount, 1);
      expect(t.memberNames, isEmpty);
    });

    test('fromJson rejects missing identity fields', () {
      expect(
        () => Team.fromJson(const <String, dynamic>{}),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('isFull is true when memberCount >= capacity', () {
      expect(
        Team.fromJson(const {
          'id': 't1',
          'title': 'Team',
          'memberCount': 5,
          'capacity': 5,
        }).isFull,
        isTrue,
      );
      expect(
        Team.fromJson(const {
          'id': 't1',
          'title': 'Team',
          'memberCount': 6,
          'capacity': 5,
        }).isFull,
        isTrue,
      );
    });

    test('isFull is false when memberCount < capacity', () {
      expect(
        Team.fromJson(const {
          'id': 't1',
          'title': 'Team',
          'memberCount': 2,
          'capacity': 5,
        }).isFull,
        isFalse,
      );
    });
  });

  group('TeamApplication', () {
    test('fromJson maps all fields', () {
      final a = TeamApplication.fromJson(const <String, dynamic>{
        'id': 'a1',
        'teamId': 't1',
        'applicantId': 'user-1',
        'role': 'design',
        'message': 'pick me',
        'applicantName': 'Kate',
        'applicantHandle': '@kate',
        'applicantGroup': 'БСБО-02',
        'attachProfile': true,
        'status': 'accepted',
        'createdAt': '2026-01-02T03:04:05Z',
      });

      expect(a.id, 'a1');
      expect(a.teamId, 't1');
      expect(a.applicantId, 'user-1');
      expect(a.role, 'design');
      expect(a.message, 'pick me');
      expect(a.applicantName, 'Kate');
      expect(a.applicantHandle, '@kate');
      expect(a.applicantGroup, 'БСБО-02');
      expect(a.attachProfile, isTrue);
      expect(a.status, TeamApplicationStatus.accepted);
      expect(a.createdAt, isNotNull);
    });

    test('fromJson defaults optional fields', () {
      final a = TeamApplication.fromJson(const <String, dynamic>{
        'id': 'a1',
        'teamId': 't1',
        'applicantId': 'user-1',
      });
      expect(a.role, '');
      expect(a.message, '');
      expect(a.applicantName, '');
      expect(a.applicantHandle, isNull);
      expect(a.applicantGroup, isNull);
      expect(a.attachProfile, isFalse);
      expect(a.status, TeamApplicationStatus.pending);
      expect(a.createdAt, isNull);
    });

    test('fromJson rejects missing identity fields', () {
      expect(
        () => TeamApplication.fromJson(const <String, dynamic>{}),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });
  });

  group('FreeRoom', () {
    test('fromJson maps all fields', () {
      final r = FreeRoom.fromJson(const <String, dynamic>{
        'room': 'А-318',
        'campus': 'В-78',
        'freeUntil': '2026-01-02T10:00:00Z',
      });

      expect(r.room, 'А-318');
      expect(r.campus, 'В-78');
      expect(r.freeUntil, isNotNull);
    });

    test('fromJson defaults', () {
      final r = FreeRoom.fromJson(const <String, dynamic>{});
      expect(r.room, '');
      expect(r.campus, isNull);
      expect(r.freeUntil, isNull);
    });

    group('building', () {
      test('extracts the Cyrillic letter prefix before a dash', () {
        expect(const FreeRoom(room: 'А-318').building, 'А');
        expect(const FreeRoom(room: 'Г-512').building, 'Г');
        expect(const FreeRoom(room: 'И-104').building, 'И');
      });

      test('extracts a multi-letter prefix before a space', () {
        expect(const FreeRoom(room: 'АБ 12').building, 'АБ');
      });

      test('extracts a Latin prefix before a dash', () {
        expect(const FreeRoom(room: 'B-204').building, 'B');
      });

      test('falls back to campus when room has no letter-separator', () {
        expect(const FreeRoom(room: '318', campus: 'В-78').building, 'В-78');
        expect(
          const FreeRoom(room: 'А12', campus: 'Кампус').building,
          'Кампус',
        );
      });

      test('falls back to empty string when no room match and no campus', () {
        expect(const FreeRoom(room: '318').building, '');
        expect(const FreeRoom(room: '').building, '');
      });
    });
  });

  group('StudyMaterial', () {
    test('fromJson maps all fields', () {
      final m = StudyMaterial.fromJson(const <String, dynamic>{
        'id': 's1',
        'title': 'Calculus',
        'subjectName': 'Math',
        'materialType': 'book',
        'downloads': 100,
        'likes': 20,
        'price': 150,
        'pages': 80,
        'authorName': 'Prof',
        'isMine': true,
        'createdAt': '2026-01-02T03:04:05Z',
      });

      expect(m.id, 's1');
      expect(m.title, 'Calculus');
      expect(m.subjectName, 'Math');
      expect(m.materialType, 'book');
      expect(m.downloads, 100);
      expect(m.likes, 20);
      expect(m.price, 150);
      expect(m.pages, 80);
      expect(m.authorName, 'Prof');
      expect(m.isMine, isTrue);
      expect(m.createdAt, isNotNull);
    });

    test('fromJson defaults; materialType defaults to "note"', () {
      final m = StudyMaterial.fromJson(const <String, dynamic>{});
      expect(m.id, '');
      expect(m.title, '');
      expect(m.subjectName, '');
      expect(m.materialType, 'note');
      expect(m.downloads, 0);
      expect(m.likes, 0);
      expect(m.price, 0);
      expect(m.pages, 0);
      expect(m.authorName, '');
      expect(m.isMine, isFalse);
      expect(m.createdAt, isNull);
    });

    test('isFree is true only when price is 0', () {
      expect(StudyMaterial.fromJson(const {'price': 0}).isFree, isTrue);
      expect(StudyMaterial.fromJson(const {}).isFree, isTrue);
      expect(StudyMaterial.fromJson(const {'price': 50}).isFree, isFalse);
    });
  });

  group('CollabNote', () {
    test('fromJson maps all fields', () {
      final n = CollabNote.fromJson(const <String, dynamic>{
        'id': 'cn1',
        'title': 'Shared',
        'content': 'text',
        'updatedByName': 'Ann',
        'isMine': true,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-02T00:00:00Z',
      });

      expect(n.id, 'cn1');
      expect(n.title, 'Shared');
      expect(n.content, 'text');
      expect(n.updatedByName, 'Ann');
      expect(n.isMine, isTrue);
      expect(n.createdAt, isNotNull);
      expect(n.updatedAt, isNotNull);
    });

    test('fromJson defaults', () {
      final n = CollabNote.fromJson(const <String, dynamic>{});
      expect(n.id, '');
      expect(n.title, '');
      expect(n.content, '');
      expect(n.updatedByName, '');
      expect(n.isMine, isFalse);
      expect(n.createdAt, isNull);
      expect(n.updatedAt, isNull);
    });
  });

  group('TeacherProfile', () {
    test('fromJson maps fields and nested reviews', () {
      final p = TeacherProfile.fromJson(const <String, dynamic>{
        'teacherName': 'Dr X',
        'reviewsCount': 2,
        'clarity': 4.5,
        'loyalty': 3.0,
        'usefulness': 5.0,
        'subjects': ['Math', 'CS'],
        'reviews': [
          {'id': 'rv1', 'clarity': 5},
          {'id': 'rv2', 'loyalty': 4},
        ],
      });

      expect(p.teacherName, 'Dr X');
      expect(p.reviewsCount, 2);
      expect(p.clarity, 4.5);
      expect(p.loyalty, 3.0);
      expect(p.usefulness, 5.0);
      expect(p.subjects, ['Math', 'CS']);
      expect(p.reviews, hasLength(2));
      expect(
        p.reviews.map((review) => review.id),
        containsAllInOrder(['rv1']),
      );
    });

    test('fromJson defaults; rating fields null when absent', () {
      final p = TeacherProfile.fromJson(const <String, dynamic>{});
      expect(p.teacherName, '');
      expect(p.reviewsCount, 0);
      expect(p.clarity, isNull);
      expect(p.loyalty, isNull);
      expect(p.usefulness, isNull);
      expect(p.subjects, isEmpty);
      expect(p.reviews, isEmpty);
    });

    test('overall averages the present rating dimensions', () {
      final p = TeacherProfile.fromJson(const <String, dynamic>{
        'clarity': 3.0,
        'loyalty': 4.0,
        'usefulness': 5.0,
      });
      expect(p.overall, 4.0);
    });

    test('overall ignores null dimensions', () {
      final p = TeacherProfile.fromJson(const <String, dynamic>{
        'clarity': 2.0,
        'usefulness': 4.0,
      });
      expect(p.overall, 3.0);
    });

    test('overall is null when no dimensions present', () {
      final p = TeacherProfile.fromJson(const <String, dynamic>{});
      expect(p.overall, isNull);
    });

    test('empty constant', () {
      expect(TeacherProfile.empty.teacherName, '');
      expect(TeacherProfile.empty.reviews, isEmpty);
    });
  });

  group('TeacherReview', () {
    test('fromJson maps all fields', () {
      final r = TeacherReview.fromJson(const <String, dynamic>{
        'id': 'rv1',
        'clarity': 5,
        'loyalty': 4,
        'usefulness': 3,
        'body': 'good',
        'authorName': 'Sam',
        'isMine': true,
        'createdAt': '2026-01-02T03:04:05Z',
      });

      expect(r.id, 'rv1');
      expect(r.clarity, 5);
      expect(r.loyalty, 4);
      expect(r.usefulness, 3);
      expect(r.body, 'good');
      expect(r.authorName, 'Sam');
      expect(r.isMine, isTrue);
      expect(r.createdAt, isNotNull);
    });

    test('fromJson defaults', () {
      final r = TeacherReview.fromJson(const <String, dynamic>{});
      expect(r.id, '');
      expect(r.clarity, 0);
      expect(r.loyalty, 0);
      expect(r.usefulness, 0);
      expect(r.body, '');
      expect(r.authorName, '');
      expect(r.isMine, isFalse);
      expect(r.createdAt, isNull);
    });

    test('average is the mean of the three dimensions', () {
      final r = TeacherReview.fromJson(const <String, dynamic>{
        'clarity': 3,
        'loyalty': 4,
        'usefulness': 5,
      });
      expect(r.average, 4.0);
    });

    test('average is 0 for all-zero defaults', () {
      expect(TeacherReview.fromJson(const <String, dynamic>{}).average, 0.0);
    });
  });

  group('MaterialAuthor', () {
    test('fromJson maps all fields', () {
      final a = MaterialAuthor.fromJson(const <String, dynamic>{
        'name': 'Top Author',
        'downloads': 500,
        'materials': 12,
      });

      expect(a.name, 'Top Author');
      expect(a.downloads, 500);
      expect(a.materials, 12);
    });

    test('fromJson defaults', () {
      final a = MaterialAuthor.fromJson(const <String, dynamic>{});
      expect(a.name, '');
      expect(a.downloads, 0);
      expect(a.materials, 0);
    });

    test('numeric fields coerce from double-like nums', () {
      final a = MaterialAuthor.fromJson(const <String, dynamic>{
        'downloads': 5.0,
        'materials': 2.0,
      });
      expect(a.downloads, 5);
      expect(a.materials, 2);
    });
  });

  group('Freezed serialization', () {
    final date = DateTime(2026, 1, 2, 3, 4, 5);

    test('round-trips group-space models', () {
      final space = GroupSpace(
        group: 'БСБО-01-22',
        hasGroup: true,
        memberNames: const ['Анна'],
        links: const [
          GroupLink(id: 'link-1', title: 'Чат', url: 'https://t.me/chat'),
        ],
        announcement: GroupAnnouncement(
          id: 'announcement-1',
          title: 'Важно',
          body: 'Текст',
          authorName: 'Староста',
          createdAt: date,
        ),
        notes: [
          GroupNote(
            id: 'note-1',
            title: 'Конспект',
            authorName: 'Иван',
            createdAt: date,
          ),
        ],
        birthdays: [GroupBirthday(name: 'Анна', date: date)],
      );

      expect(GroupSpace.fromJson(space.toJson()), space);
      expect(space.toJson(), contains('memberNames'));
    });

    test('round-trips campus and marketplace models', () {
      final event = CampusEvent(id: 'event-1', title: 'Митап', startsAt: date);
      final listing = MarketListing(
        id: 'listing-1',
        title: 'Учебник',
        price: 100,
        createdAt: date,
      );
      final room = FreeRoom(room: 'А-101', campus: 'А', freeUntil: date);

      expect(CampusEvent.fromJson(event.toJson()), event);
      expect(MarketListing.fromJson(listing.toJson()), listing);
      expect(FreeRoom.fromJson(room.toJson()), room);
    });

    test('round-trips mentorship and team models', () {
      const mentor = Mentor(userId: 'user-1', fullName: 'Анна');
      final request = MentorRequest(
        id: 'request-1',
        mentorUserId: 'mentor-1',
        requesterId: 'requester-1',
        createdAt: date,
      );
      final team = Team(id: 'team-1', title: 'Команда', createdAt: date);
      final application = TeamApplication(
        id: 'application-1',
        teamId: 'team-1',
        applicantId: 'user-1',
        createdAt: date,
      );

      expect(Mentor.fromJson(mentor.toJson()), mentor);
      expect(MentorRequest.fromJson(request.toJson()), request);
      expect(Team.fromJson(team.toJson()), team);
      expect(TeamApplication.fromJson(application.toJson()), application);
    });

    test('round-trips knowledge and teacher models', () {
      final material = StudyMaterial(
        id: 'material-1',
        title: 'Матан',
        createdAt: date,
      );
      final note = CollabNote(
        id: 'note-1',
        title: 'Лаба',
        createdAt: date,
        updatedAt: date,
      );
      const author = MaterialAuthor(name: 'Анна', materials: 2);
      final profile = TeacherProfile(
        teacherName: 'Иванов',
        reviews: [TeacherReview(id: 'review-1', createdAt: date)],
      );

      expect(StudyMaterial.fromJson(material.toJson()), material);
      expect(CollabNote.fromJson(note.toJson()), note);
      expect(MaterialAuthor.fromJson(author.toJson()), author);
      expect(TeacherProfile.fromJson(profile.toJson()), profile);
    });

    test(
      'equality includes fields previously omitted from Equatable props',
      () {
        const first = MarketListing(id: 'same', title: 'Первый', price: 100);
        const second = MarketListing(id: 'same', title: 'Второй', price: 100);

        expect(first, isNot(second));
      },
    );
  });
}
