import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/events/events.dart';
import 'package:rtu_mirea_app/community/models/event_draft.dart';

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
      'loads all events including past ones',
      setUp: () {
        when(
          () => repository.getEvents(includePast: true),
        ).thenAnswer((_) async => [careerEvent, sportEvent]);
      },
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const EventsState(status: .loading),
        EventsState(status: .ready, events: [careerEvent, sportEvent]),
      ],
      verify: (_) {
        verify(() => repository.getEvents(includePast: true)).called(1);
      },
    );

    test('ignores a superseded load response', () async {
      final first = Completer<List<CampusEvent>>();
      final second = Completer<List<CampusEvent>>();
      var request = 0;
      when(
        () => repository.getEvents(includePast: true),
      ).thenAnswer((_) {
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
        () => repository.getEvents(includePast: true),
      ).thenAnswer((_) async => [careerEvent]);
      final cubit = buildCubit();
      await cubit.load();
      when(
        () => repository.getEvents(includePast: true),
      ).thenThrow(Exception('offline'));

      expect(await cubit.load(), isFalse);
      expect(cubit.state.status, EventsStatus.failure);
      expect(cubit.state.events, [careerEvent]);
      await cubit.close();
    });

    test(
      'prevents duplicate RSVP requests and updates optimistically',
      () async {
        var loadCount = 0;
        when(
          () => repository.getEvents(includePast: true),
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
        verify(() => repository.getEvents(includePast: true)).called(2);
        await cubit.close();
      },
    );

    test('a stale refresh cannot overwrite a successful RSVP', () async {
      final staleRefresh = Completer<List<CampusEvent>>();
      var loadCount = 0;
      when(
        () => repository.getEvents(includePast: true),
      ).thenAnswer((_) {
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

    blocTest<EventsCubit, EventsState>(
      'rolls RSVP back when the repository rejects it',
      setUp: () {
        when(
          () => repository.getEvents(includePast: true),
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
        EventsState(status: .ready, events: [careerEvent]),
      ],
      errors: () => [isA<Exception>()],
    );

    test('creates an event with an optional end time and refreshes', () async {
      final draft = EventDraft(
        title: 'Open lecture',
        startsAt: DateTime(2026, 9, 3, 16),
        endsAt: DateTime(2026, 9, 3, 18),
        emoji: '🎤',
        category: .science,
        place: 'A-100',
        description: 'For everyone',
      );
      when(
        () => repository.createEvent(
          title: any(named: 'title'),
          startsAt: any(named: 'startsAt'),
          endsAt: any(named: 'endsAt'),
          place: any(named: 'place'),
          emoji: any(named: 'emoji'),
          category: any(named: 'category'),
          description: any(named: 'description'),
        ),
      ).thenAnswer((_) => Future.value());
      when(
        () => repository.getEvents(includePast: true),
      ).thenAnswer((_) async => [sportEvent]);
      final cubit = buildCubit();

      expect(await cubit.createEvent(draft), isTrue);
      expect(cubit.state.events, [sportEvent]);
      expect(cubit.state.isCreating, isFalse);
      verify(
        () => repository.createEvent(
          title: 'Open lecture',
          startsAt: DateTime(2026, 9, 3, 16),
          endsAt: DateTime(2026, 9, 3, 18),
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
            endsAt: any(named: 'endsAt'),
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

    test('updates an own event and refreshes the board', () async {
      final draft = EventDraft(
        title: 'Renamed lecture',
        startsAt: DateTime(2026, 9, 3, 16),
        emoji: '🎤',
        category: .science,
      );
      when(
        () => repository.updateEvent(
          id: 'career-1',
          title: any(named: 'title'),
          startsAt: any(named: 'startsAt'),
          endsAt: any(named: 'endsAt'),
          place: any(named: 'place'),
          emoji: any(named: 'emoji'),
          category: any(named: 'category'),
          description: any(named: 'description'),
        ),
      ).thenAnswer((_) => Future.value());
      when(
        () => repository.getEvents(includePast: true),
      ).thenAnswer((_) async => [careerEvent]);
      final cubit = buildCubit();

      expect(await cubit.updateEvent('career-1', draft), isTrue);
      expect(cubit.state.isSaving, isFalse);
      verify(
        () => repository.updateEvent(
          id: 'career-1',
          title: 'Renamed lecture',
          startsAt: any(named: 'startsAt'),
          place: '',
          emoji: '🎤',
          category: 'sci',
          description: '',
        ),
      ).called(1);
      await cubit.close();
    });

    test('reports update failure without a stale saving flag', () async {
      when(
        () => repository.updateEvent(
          id: any(named: 'id'),
          title: any(named: 'title'),
          startsAt: any(named: 'startsAt'),
          endsAt: any(named: 'endsAt'),
          place: any(named: 'place'),
          emoji: any(named: 'emoji'),
          category: any(named: 'category'),
          description: any(named: 'description'),
        ),
      ).thenThrow(Exception('rls'));
      final cubit = buildCubit();

      final saved = await cubit.updateEvent(
        'career-1',
        EventDraft(
          title: 'Renamed lecture',
          startsAt: DateTime(2026, 9, 3, 16),
          emoji: '🎤',
          category: .science,
        ),
      );

      expect(saved, isFalse);
      expect(cubit.state.isSaving, isFalse);
      await cubit.close();
    });

    test('deletes an event and refreshes the board', () async {
      when(
        () => repository.deleteEvent('career-1'),
      ).thenAnswer((_) => Future.value());
      when(
        () => repository.getEvents(includePast: true),
      ).thenAnswer((_) async => [sportEvent]);
      final cubit = buildCubit();

      expect(await cubit.deleteEvent('career-1'), isTrue);
      expect(cubit.state.events, [sportEvent]);
      verify(() => repository.deleteEvent('career-1')).called(1);
      await cubit.close();
    });

    test('reports delete failure', () async {
      when(
        () => repository.deleteEvent('career-1'),
      ).thenThrow(Exception('rls'));
      final cubit = buildCubit();

      expect(await cubit.deleteEvent('career-1'), isFalse);
      await cubit.close();
    });
  });
}
