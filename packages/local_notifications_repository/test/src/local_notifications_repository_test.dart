import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications_client/local_notifications_client.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_client/permission_client.dart';

class _MockClient extends Mock implements LocalNotificationsClient {}

class _MockPermissionClient extends Mock implements PermissionClient {}

void main() {
  setUpAll(() => registerFallbackValue(DateTime(2030)));

  late _MockClient client;
  late _MockPermissionClient permissionClient;
  late LocalNotificationsRepository repository;

  setUp(() {
    client = _MockClient();
    permissionClient = _MockPermissionClient();
    repository = LocalNotificationsRepository(
      client: client,
      permissionClient: permissionClient,
    );
    when(client.init).thenAnswer((_) async {});
    when(
      permissionClient.notificationsStatus,
    ).thenAnswer((_) async => PermissionStatus.granted);
    when(() => client.cancel(any())).thenAnswer((_) async {});
    when(
      () => client.schedule(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        when: any(named: 'when'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});
  });

  group('syncLessonReminders', () {
    test('permission denial leaves existing reminders untouched', () async {
      when(
        permissionClient.notificationsStatus,
      ).thenAnswer((_) async => PermissionStatus.denied);
      await expectLater(
        repository.syncLessonReminders(
          scheduleId: 's',
          reminders: [
            LessonReminder(id: 1, title: 't', body: 'b', when: DateTime(2030)),
          ],
        ),
        throwsA(isA<SyncRemindersFailure>()),
      );
      verifyNever(() => client.cancel(any()));
      verifyNever(client.pending);
    });

    test('a scheduling failure preserves the previous reminder set', () async {
      when(
        client.pending,
      ).thenAnswer((_) async => const [PendingReminder(id: 1, payload: 's')]);
      when(
        () => client.schedule(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          when: any(named: 'when'),
          payload: any(named: 'payload'),
        ),
      ).thenThrow(Exception('schedule failed'));
      await expectLater(
        repository.syncLessonReminders(
          scheduleId: 's',
          reminders: [
            LessonReminder(id: 2, title: 't', body: 'b', when: DateTime(2030)),
          ],
        ),
        throwsA(isA<SyncRemindersFailure>()),
      );
      verifyNever(() => client.cancel(1));
    });
    test('replaces a schedule without changing foreign reminders', () async {
      when(client.pending).thenAnswer(
        (_) async => const [
          PendingReminder(id: 1, payload: 'sched-A'),
          PendingReminder(id: 2, payload: 'sched-B'),
        ],
      );

      await repository.syncLessonReminders(
        scheduleId: 'sched-A',
        reminders: [
          LessonReminder(
            id: 10,
            title: 'Машинное обучение',
            body: 'Начало в 10:40',
            when: DateTime(2030, 1, 1, 10, 25),
          ),
        ],
      );

      verify(() => client.cancel(1)).called(1); // belongs to sched-A
      verifyNever(() => client.cancel(2)); // belongs to sched-B
      verify(
        () => client.schedule(
          id: 10,
          title: 'Машинное обучение',
          body: 'Начало в 10:40',
          when: DateTime(2030, 1, 1, 10, 25),
          payload: 'sched-A',
        ),
      ).called(1);
    });

    test(
      'replacement stays below the device pending notification limit',
      () async {
        final pending = <int>{for (var i = 0; i < 60; i++) i};
        when(client.pending).thenAnswer(
          (_) async => [
            for (final id in pending) PendingReminder(id: id, payload: 's'),
          ],
        );
        when(() => client.cancel(any())).thenAnswer((invocation) async {
          pending.remove(invocation.positionalArguments.single as int);
        });
        when(
          () => client.schedule(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            when: any(named: 'when'),
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((invocation) async {
          pending.add(invocation.namedArguments[#id]! as int);
          expect(pending.length, lessThanOrEqualTo(64));
        });
        await repository.syncLessonReminders(
          scheduleId: 's',
          reminders: [
            for (var i = 100; i < 160; i++)
              LessonReminder(
                id: i,
                title: 't',
                body: 'b',
                when: DateTime(2030),
              ),
          ],
        );
        expect(pending, {for (var i = 100; i < 160; i++) i});
      },
    );

    test(
      'does not overwrite a colliding foreign notification identifier',
      () async {
        when(client.pending).thenAnswer(
          (_) async => const [PendingReminder(id: 1, payload: 'foreign')],
        );
        await expectLater(
          repository.syncLessonReminders(
            scheduleId: 's',
            reminders: [
              LessonReminder(
                id: 1,
                title: 't',
                body: 'b',
                when: DateTime(2030),
              ),
            ],
          ),
          throwsA(isA<SyncRemindersFailure>()),
        );
        verifyNever(() => client.cancel(any()));
        verifyNever(
          () => client.schedule(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            when: any(named: 'when'),
            payload: any(named: 'payload'),
          ),
        );
      },
    );

    test('caps at maxScheduledReminders and keeps the soonest', () async {
      when(client.pending).thenAnswer((_) async => const []);

      // when = base + (70 - i) days → i=69 is the soonest, i=0 the latest.
      final reminders = [
        for (var i = 0; i < 70; i++)
          LessonReminder(
            id: i,
            title: 't$i',
            body: 'b',
            when: DateTime(2030).add(Duration(days: 70 - i)),
          ),
      ];

      await repository.syncLessonReminders(
        scheduleId: 's',
        reminders: reminders,
      );

      verify(
        () => client.schedule(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          when: any(named: 'when'),
          payload: any(named: 'payload'),
        ),
      ).called(LocalNotificationsRepository.maxScheduledReminders);

      // The latest reminder (id 0) is beyond the soonest 60 and is dropped.
      verifyNever(
        () => client.schedule(
          id: 0,
          title: any(named: 'title'),
          body: any(named: 'body'),
          when: any(named: 'when'),
          payload: any(named: 'payload'),
        ),
      );
    });

    test('does not schedule reminders in the past', () async {
      when(client.pending).thenAnswer((_) async => const []);
      final now = DateTime.now();

      await repository.syncLessonReminders(
        scheduleId: 's',
        reminders: [
          LessonReminder(
            id: 1,
            title: 'Past',
            body: 'Past',
            when: now.subtract(const Duration(minutes: 1)),
          ),
          LessonReminder(
            id: 2,
            title: 'Future',
            body: 'Future',
            when: now.add(const Duration(minutes: 1)),
          ),
        ],
      );

      verify(
        () => client.schedule(
          id: 2,
          title: 'Future',
          body: 'Future',
          when: any(named: 'when'),
          payload: 's',
        ),
      ).called(1);
      verifyNever(
        () => client.schedule(
          id: 1,
          title: any(named: 'title'),
          body: any(named: 'body'),
          when: any(named: 'when'),
          payload: any(named: 'payload'),
        ),
      );
    });
  });

  group('initialize', () {
    test('retries after a failed initialization', () async {
      var attempts = 0;
      when(client.init).thenAnswer((_) async {
        attempts++;
        if (attempts == 1) throw Exception('Temporary initialization failure');
      });

      await expectLater(repository.initialize(), throwsA(isA<Exception>()));
      await expectLater(repository.initialize(), completes);

      expect(attempts, 2);
    });
  });

  group('cancelSchedule', () {
    test('cancels only the matching payload', () async {
      when(client.pending).thenAnswer(
        (_) async => const [
          PendingReminder(id: 1, payload: 'keep'),
          PendingReminder(id: 2, payload: 'drop'),
        ],
      );

      await repository.cancelSchedule('drop');

      verify(() => client.cancel(2)).called(1);
      verifyNever(() => client.cancel(1));
    });
  });

  group('ensurePermission', () {
    test('returns true when the OS grants notifications', () async {
      when(
        permissionClient.requestNotifications,
      ).thenAnswer((_) async => PermissionStatus.granted);

      expect(await repository.ensurePermission(), isTrue);
    });

    test('returns false when denied', () async {
      when(
        permissionClient.requestNotifications,
      ).thenAnswer((_) async => PermissionStatus.denied);

      expect(await repository.ensurePermission(), isFalse);
    });
  });

  group('hasPermission', () {
    test('returns the current OS permission without requesting it', () async {
      when(
        permissionClient.notificationsStatus,
      ).thenAnswer((_) async => PermissionStatus.granted);

      expect(await repository.hasPermission(), isTrue);
      verifyNever(permissionClient.requestNotifications);
    });
  });
}
