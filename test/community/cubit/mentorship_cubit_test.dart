import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/community/view/mentorship_labels.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';

import '../../helpers/mocks/mock_campus_repository.dart';

void main() {
  group('MentorshipCubit', () {
    late CampusRepository repository;
    const mentor = Mentor(
      userId: 'mentor-1',
      fullName: 'Mentor',
      topics: ['python'],
    );
    const request = MentorRequest(
      id: 'request-1',
      mentorUserId: 'mentor-1',
      requesterId: 'requester-1',
    );

    setUp(() => repository = MockCampusRepository());

    MentorshipCubit buildCubit() => .new(repository: repository);

    blocTest<MentorshipCubit, MentorshipState>(
      'loads mentors before the independent request history',
      setUp: () {
        when(() => repository.getMentors()).thenAnswer((_) async => [mentor]);
        when(
          () => repository.getMyMentorRequests(),
        ).thenAnswer((_) async => [request]);
      },
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const MentorshipState(status: .loading),
        const MentorshipState(
          status: .ready,
          mentors: [mentor],
          requestsStatus: .loading,
        ),
        const MentorshipState(
          status: .ready,
          mentors: [mentor],
          requests: [request],
          requestsStatus: .ready,
        ),
      ],
    );

    test('ignores a superseded load', () async {
      final first = Completer<List<Mentor>>();
      var calls = 0;
      when(() => repository.getMentors()).thenAnswer(
        (_) => calls++ == 0 ? first.future : Future.value([mentor]),
      );
      when(
        () => repository.getMyMentorRequests(),
      ).thenAnswer((_) async => [request]);
      final cubit = buildCubit();

      final loads = (cubit.load(), cubit.load());
      await loads.$2;
      first.complete(const []);
      await loads.$1;

      expect(cubit.state.mentors, [mentor]);
      expect(cubit.state.requests, [request]);
      await cubit.close();
    });

    blocTest<MentorshipCubit, MentorshipState>(
      'keeps cached mentors and reports a refresh failure',
      seed: () => const MentorshipState(status: .ready, mentors: [mentor]),
      setUp: () => when(
        () => repository.getMentors(),
      ).thenThrow(Exception('offline')),
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const MentorshipState(status: .loading, mentors: [mentor]),
        const MentorshipState(status: .failure, mentors: [mentor]),
      ],
      errors: () => [isA<Exception>()],
    );

    blocTest<MentorshipCubit, MentorshipState>(
      'shows request failure without hiding loaded mentors',
      setUp: () {
        when(() => repository.getMentors()).thenAnswer((_) async => [mentor]);
        when(
          () => repository.getMyMentorRequests(),
        ).thenThrow(Exception('offline'));
      },
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const MentorshipState(status: .loading),
        const MentorshipState(
          status: .ready,
          mentors: [mentor],
          requestsStatus: .loading,
        ),
        const MentorshipState(
          status: .ready,
          mentors: [mentor],
          requestsStatus: .failure,
        ),
      ],
      errors: () => [isA<Exception>()],
    );

    test('normalizes a profile and prevents duplicate saves', () async {
      final saved = Completer<void>();
      when(
        () => repository.upsertMentorProfile(
          topics: ['python'],
          telegramHandle: 'mentor_ninja',
          bio: 'Help with Dart',
          level: 'course3',
          formats: ['chat'],
          price: 15,
        ),
      ).thenAnswer((_) => saved.future);
      when(() => repository.getMentors()).thenAnswer((_) async => [mentor]);
      when(
        () => repository.getMyMentorRequests(),
      ).thenAnswer((_) async => const []);
      final cubit = buildCubit();
      const draft = MentorProfileDraft(
        topics: [' python ', 'python'],
        telegramHandle: ' @mentor_ninja ',
        bio: ' Help with Dart ',
        level: ' course3 ',
        formats: [' chat '],
        price: 15,
      );

      final firstSave = cubit.saveProfile(draft);
      expect(await cubit.saveProfile(draft), isFalse);
      saved.complete();
      expect(await firstSave, isTrue);

      verify(
        () => repository.upsertMentorProfile(
          topics: ['python'],
          telegramHandle: 'mentor_ninja',
          bio: 'Help with Dart',
          level: 'course3',
          formats: ['chat'],
          price: 15,
        ),
      ).called(1);
      await cubit.close();
    });

    test('rejects a save with an invalid Telegram handle', () async {
      final cubit = buildCubit();
      const draft = MentorProfileDraft(
        topics: ['python'],
        telegramHandle: 'no',
      );

      expect(await cubit.saveProfile(draft), isFalse);
      verifyNever(
        () => repository.upsertMentorProfile(
          topics: any(named: 'topics'),
          telegramHandle: any(named: 'telegramHandle'),
        ),
      );
      await cubit.close();
    });

    test('locks each mentor while sending a typed request', () async {
      final sent = Completer<void>();
      when(
        () => repository.createMentorRequest(
          mentorUserId: 'mentor-1',
          topic: 'python',
          whenSlot: 'tomorrow',
          message: 'Can you help?',
        ),
      ).thenAnswer((_) => sent.future);
      final cubit = buildCubit();
      const draft = MentorRequestDraft(
        mentorUserId: 'mentor-1',
        topic: ' python ',
        whenSlot: .tomorrow,
        message: ' Can you help? ',
      );

      final firstSend = cubit.sendRequest(draft);
      expect(cubit.state.pendingMentorIds, {'mentor-1'});
      expect(await cubit.sendRequest(draft), isFalse);
      sent.complete();
      expect(await firstSend, isTrue);

      verify(
        () => repository.createMentorRequest(
          mentorUserId: 'mentor-1',
          topic: 'python',
          whenSlot: 'tomorrow',
          message: 'Can you help?',
        ),
      ).called(1);
      expect(cubit.state.pendingMentorIds, isEmpty);
      await cubit.close();
    });

    test('acts once on a known request and reloads lifecycle state', () async {
      when(
        () => repository.actOnMentorRequest(
          id: 'request-1',
          action: .accept,
        ),
      ).thenAnswer((_) => Future.value());
      when(() => repository.getMentors()).thenAnswer((_) async => [mentor]);
      var requestLoads = 0;
      when(() => repository.getMyMentorRequests()).thenAnswer(
        (_) async => requestLoads++ == 0
            ? [request]
            : [request.copyWith(status: .accepted)],
      );
      final cubit = buildCubit();
      await cubit.load();

      expect(
        await cubit.actOnRequest('request-1', .accept),
        isTrue,
      );

      verify(
        () => repository.actOnMentorRequest(
          id: 'request-1',
          action: .accept,
        ),
      ).called(1);
      const accepted = MentorRequestStatus.accepted;
      expect(cubit.state.requests.singleOrNull?.status, accepted);
      expect(cubit.state.pendingRequestIds, isEmpty);
      await cubit.close();
    });
  });

  group('isValidMentorTelegramHandle', () {
    test('accepts a bare or @-prefixed handle within the length bounds', () {
      expect(isValidMentorTelegramHandle('mentor_ninja'), isTrue);
      expect(isValidMentorTelegramHandle('@mentor_ninja'), isTrue);
      expect(isValidMentorTelegramHandle(' @mentor_ninja '), isTrue);
    });

    test('rejects handles that are too short, too long or malformed', () {
      expect(isValidMentorTelegramHandle(''), isFalse);
      expect(isValidMentorTelegramHandle('no'), isFalse);
      expect(isValidMentorTelegramHandle('a' * 33), isFalse);
      expect(isValidMentorTelegramHandle('bad handle'), isFalse);
      expect(isValidMentorTelegramHandle('bad-handle'), isFalse);
    });
  });

  group('mentorMatchesQuery', () {
    final l10n = AppLocalizationsRu();
    const mentor = Mentor(
      userId: 'mentor-1',
      fullName: 'Мария Иванова',
      group: 'ИКБО-01-23',
      bio: 'Помогаю с алгоритмами',
      topics: ['python', 'career'],
    );

    test('matches an empty query', () {
      expect(mentorMatchesQuery(l10n, mentor, ''), isTrue);
    });

    test('matches by name, group, bio and topic label', () {
      expect(mentorMatchesQuery(l10n, mentor, 'мария'), isTrue);
      expect(mentorMatchesQuery(l10n, mentor, 'икбо'), isTrue);
      expect(mentorMatchesQuery(l10n, mentor, 'алгоритм'), isTrue);
      expect(mentorMatchesQuery(l10n, mentor, 'python'), isTrue);
    });

    test('does not match an unrelated query', () {
      expect(mentorMatchesQuery(l10n, mentor, 'дизайн'), isFalse);
    });
  });
}
