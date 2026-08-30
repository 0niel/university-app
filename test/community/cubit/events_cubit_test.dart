import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';

import '../../helpers/mocks/mock_campus_repository.dart';

void main() {
  group('EventsCubit', () {
    late CampusRepository repository;
    late CampusEvent careerEvent;
    late CampusEvent sportEvent;

    setUp(() {
      repository = MockCampusRepository();
      careerEvent = CampusEvent(
        id: 'career-1',
        title: 'Career day',
        startsAt: DateTime(2026, 9, 1, 12),
        category: 'career',
        goingCount: 4,
      );
      sportEvent = CampusEvent(
        id: 'sport-1',
        title: 'Basketball',
        startsAt: DateTime(2026, 9, 2, 18),
        category: 'sport',
        goingCount: 12,
      );
    });

    EventsCubit buildCubit() => .new(repository: repository);

    test('starts with an empty initial state', () {
      expect(buildCubit().state, const EventsState());
    });

    blocTest<EventsCubit, EventsState>(
      'loads events',
      setUp: () {
        when(
          () => repository.getEvents(),
        ).thenAnswer((_) async => [careerEvent, sportEvent]);
      },
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const EventsState(status: .loading),
        EventsState(
          status: .ready,
          events: [careerEvent, sportEvent],
        ),
      ],
    );

    test('ignores a superseded load response', () async {
      final first = Completer<List<CampusEvent>>();
      final second = Completer<List<CampusEvent>>();
      var request = 0;
      when(() => repository.getEvents()).thenAnswer((_) {
        request++;
        return request == 1 ? first.future : second.future;
      });
      final cubit = buildCubit();

      final loads = (cubit.load(), cubit.load());
      second.complete([sportEvent]);
      await loads.$2;
      first.complete([careerEvent]);
      await loads.$1;

      expect(cubit.state.events, [sportEvent]);
      expect(cubit.state.status, EventsStatus.ready);
      await cubit.close();
    });

    test('keeps cached events when refresh fails', () async {
      when(
        () => repository.getEvents(),
      ).thenAnswer((_) async => [careerEvent]);
      final cubit = buildCubit();
      await cubit.load();
      when(() => repository.getEvents()).thenThrow(Exception('offline'));

      expect(await cubit.load(), isFalse);
      expect(cubit.state.status, EventsStatus.failure);
      expect(cubit.state.events, [careerEvent]);
      await cubit.close();
    });

    test('filters events and selects the most attended feature', () {
      final state = EventsState(
        status: .ready,
        events: [careerEvent, sportEvent],
      );

      expect(state.featuredEvent, sportEvent);
      expect(state.upcomingEvents, [careerEvent]);
      expect(
        state.copyWith(category: .career).filteredEvents,
        [careerEvent],
      );
    });

    test(
      'prevents duplicate RSVP requests and updates optimistically',
      () async {
        var loadCount = 0;
        when(
          () => repository.getEvents(),
        ).thenAnswer((_) async {
          loadCount++;
          final event = loadCount == 1
              ? careerEvent
              : careerEvent.copyWith(isGoing: true, goingCount: 5);
          return [event];
        });
        final mutation = Completer<void>();
        when(
          () => repository.setEventRsvp(eventId: 'career-1', going: true),
        ).thenAnswer((_) => mutation.future);
        final cubit = buildCubit();
        await cubit.load();

        final toggles = (
          cubit.toggleRsvp('career-1'),
          cubit.toggleRsvp('career-1'),
        );

        expect(cubit.state.events.firstOrNull?.isGoing, isTrue);
        expect(cubit.state.events.firstOrNull?.goingCount, 5);
        expect(cubit.state.pendingRsvps, {'career-1'});
        expect(await toggles.$2, isTrue);
        verify(
          () => repository.setEventRsvp(eventId: 'career-1', going: true),
        ).called(1);

        mutation.complete();
        expect(await toggles.$1, isTrue);
        expect(cubit.state.pendingRsvps, isEmpty);
        verify(() => repository.getEvents()).called(2);
        await cubit.close();
      },
    );

    test('a stale refresh cannot overwrite a successful RSVP', () async {
      final staleRefresh = Completer<List<CampusEvent>>();
      var loadCount = 0;
      when(() => repository.getEvents()).thenAnswer((_) {
        loadCount++;
        return switch (loadCount) {
          1 => Future.value([careerEvent]),
          2 => staleRefresh.future,
          _ => Future.value([
            careerEvent.copyWith(isGoing: true, goingCount: 5),
          ]),
        };
      });
      final mutation = Completer<void>();
      when(
        () => repository.setEventRsvp(eventId: 'career-1', going: true),
      ).thenAnswer((_) => mutation.future);
      final cubit = buildCubit();
      await cubit.load();

      final toggle = cubit.toggleRsvp('career-1');
      final refresh = cubit.load();
      mutation.complete();
      expect(await toggle, isTrue);
      staleRefresh.complete([careerEvent]);
      expect(await refresh, isFalse);

      expect(cubit.state.events.firstOrNull?.isGoing, isTrue);
      expect(cubit.state.events.firstOrNull?.goingCount, 5);
      await cubit.close();
    });

    test('successful RSVP cancellation refreshes attendee names', () async {
      final attending = careerEvent.copyWith(
        isGoing: true,
        goingCount: 1,
        goingNames: ['Current user'],
      );
      var loadCount = 0;
      when(() => repository.getEvents()).thenAnswer((_) async {
        loadCount++;
        final event = loadCount == 1
            ? attending
            : attending.copyWith(
                isGoing: false,
                goingCount: 0,
                goingNames: const [],
              );
        return [event];
      });
      when(
        () => repository.setEventRsvp(eventId: 'career-1', going: false),
      ).thenAnswer((_) => Future.value());
      final cubit = buildCubit();
      await cubit.load();

      expect(await cubit.toggleRsvp('career-1'), isTrue);

      expect(cubit.state.events.firstOrNull?.isGoing, isFalse);
      expect(cubit.state.events.firstOrNull?.goingNames, isEmpty);
      await cubit.close();
    });

    test(
      'failed RSVP reconciliation does not keep stale attendee names',
      () async {
        final attending = careerEvent.copyWith(
          isGoing: true,
          goingCount: 1,
          goingNames: ['Current user'],
        );
        var loadCount = 0;
        when(() => repository.getEvents()).thenAnswer((_) async {
          loadCount++;
          if (loadCount == 1) return [attending];
          throw Exception('offline');
        });
        when(
          () => repository.setEventRsvp(eventId: 'career-1', going: false),
        ).thenAnswer((_) => Future.value());
        final cubit = buildCubit();
        await cubit.load();

        expect(await cubit.toggleRsvp('career-1'), isTrue);

        expect(cubit.state.status, EventsStatus.failure);
        expect(cubit.state.events.firstOrNull?.isGoing, isFalse);
        expect(cubit.state.events.firstOrNull?.goingCount, 0);
        expect(cubit.state.events.firstOrNull?.goingNames, isEmpty);
        await cubit.close();
      },
    );

    blocTest<EventsCubit, EventsState>(
      'rolls RSVP back when the repository rejects it',
      setUp: () {
        when(
          () => repository.getEvents(),
        ).thenAnswer((_) async => [careerEvent]);
        when(
          () => repository.setEventRsvp(eventId: 'career-1', going: true),
        ).thenThrow(Exception('rls'));
      },
      build: buildCubit,
      act: (cubit) async {
        await cubit.load();
        expect(await cubit.toggleRsvp('career-1'), isFalse);
      },
      skip: 2,
      expect: () => [
        EventsState(
          status: .ready,
          events: [careerEvent.copyWith(isGoing: true, goingCount: 5)],
          pendingRsvps: {'career-1'},
        ),
        EventsState(
          status: .ready,
          events: [careerEvent],
        ),
      ],
      errors: () => [isA<Exception>()],
    );

    test('creates an event and refreshes the board', () async {
      final draft = EventDraft(
        title: 'Open lecture',
        startsAt: DateTime(2026, 9, 3, 16),
        emoji: '🎤',
        category: .science,
        place: 'A-100',
        description: 'For everyone',
      );
      when(
        () => repository.createEvent(
          title: any(named: 'title'),
          startsAt: any(named: 'startsAt'),
          place: any(named: 'place'),
          emoji: any(named: 'emoji'),
          category: any(named: 'category'),
          description: any(named: 'description'),
        ),
      ).thenAnswer((_) => Future.value());
      when(
        () => repository.getEvents(),
      ).thenAnswer((_) async => [sportEvent]);
      final cubit = buildCubit();

      expect(await cubit.createEvent(draft), isTrue);
      expect(cubit.state.events, [sportEvent]);
      expect(cubit.state.isCreating, isFalse);
      verify(
        () => repository.createEvent(
          title: 'Open lecture',
          startsAt: DateTime(2026, 9, 3, 16),
          place: 'A-100',
          emoji: '🎤',
          category: 'sci',
          description: 'For everyone',
        ),
      ).called(1);
      await cubit.close();
    });

    blocTest<EventsCubit, EventsState>(
      'reports create failure and restores the creating flag',
      setUp: () {
        when(
          () => repository.createEvent(
            title: any(named: 'title'),
            startsAt: any(named: 'startsAt'),
            place: any(named: 'place'),
            emoji: any(named: 'emoji'),
            category: any(named: 'category'),
            description: any(named: 'description'),
          ),
        ).thenThrow(Exception('rls'));
      },
      build: buildCubit,
      act: (cubit) async {
        final created = await cubit.createEvent(
          EventDraft(
            title: 'Open lecture',
            startsAt: DateTime(2026, 9, 3, 16),
            emoji: '🎤',
            category: .science,
          ),
        );
        expect(created, isFalse);
      },
      expect: () => [
        const EventsState(isCreating: true),
        const EventsState(),
      ],
      errors: () => [isA<Exception>()],
    );
  });
}
