import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/common/bloc/remote_preference_sync.dart';

class RemotePreferenceSyncTest extends Cubit<int>
    with RemotePreferenceSync<int> {
  RemotePreferenceSyncTest(
    this.preferencesRepository, {
    this.throwOnRestore = false,
  }) : super(0);

  @override
  final PreferencesRepository preferencesRepository;

  final List<RemotePreferenceSyncStatus> statuses = [];
  int restoredCount = 0;
  final bool throwOnRestore;

  @override
  String get preferenceKey => 'test';

  @override
  Duration get remotePreferencePushDelay => const .new(days: 1);

  @override
  int? fromPreferencePayload(Map<String, dynamic> payload) =>
      payload['value'] as int?;

  @override
  Map<String, dynamic> toPreferencePayload(int state) => {'value': state};

  @override
  void onRemotePreferenceSyncStatusChanged(
    RemotePreferenceSyncStatus status,
  ) => statuses.add(status);

  @override
  void onRemotePreferenceRestored(int previous, int restored) {
    if (throwOnRestore) throw StateError('restore hook failed');
    restoredCount++;
  }

  void valueChanged(int value) => emit(value);
}

class MockPreferencesRepository extends Mock implements PreferencesRepository {}

UserPreferenceEntry _entry(int value, int revision) => .new(
  key: 'test',
  value: {'value': value},
  revision: revision,
  updatedAt: DateTime.utc(2026),
);

void main() {
  late MockPreferencesRepository repository;

  setUp(() {
    repository = MockPreferencesRepository();
    when(() => repository.hasAuthenticatedUser).thenReturn(true);
  });

  test('an in-flight restore cannot overwrite a local mutation', () async {
    final remote = Completer<UserPreferenceEntry?>();
    when(() => repository.get('test')).thenAnswer((_) => remote.future);
    when(
      () => repository.setVersioned(
        'test',
        any(),
        expectedRevision: any(named: 'expectedRevision'),
      ),
    ).thenAnswer((_) async => 4);
    final cubit = RemotePreferenceSyncTest(repository);

    final restore = cubit.restoreFromRemote();
    cubit.valueChanged(7);
    remote.complete(_entry(1, 3));
    await restore;

    expect(cubit.state, 7);
    expect(cubit.restoredCount, 0);
    await cubit.close();
  });

  test('serializes writes and drains only the newest queued state', () async {
    when(() => repository.get('test')).thenAnswer((_) async => _entry(0, 1));
    final firstWrite = Completer<int>();
    final secondWrite = Completer<int>();
    final payloads = <Map<String, dynamic>>[];
    var calls = 0;
    when(
      () => repository.setVersioned(
        'test',
        any(),
        expectedRevision: any(named: 'expectedRevision'),
      ),
    ).thenAnswer((invocation) {
      payloads.add(invocation.positionalArguments[1] as Map<String, dynamic>);
      return calls++ == 0 ? firstWrite.future : secondWrite.future;
    });
    final cubit = RemotePreferenceSyncTest(repository);
    await cubit.restoreFromRemote();

    cubit.valueChanged(1);
    final flush = cubit.flushRemotePreferences();
    await Future<void>.delayed(.zero);
    cubit
      ..valueChanged(2)
      ..valueChanged(3);
    expect(calls, 1);

    firstWrite.complete(2);
    await Future<void>.delayed(.zero);
    expect(calls, 2);
    secondWrite.complete(3);
    await flush;

    expect(payloads, [
      {'value': 1},
      {'value': 3},
    ]);
    await cubit.close();
  });

  test('close flushes the debounced value before closing', () async {
    when(() => repository.get('test')).thenAnswer((_) async => _entry(0, 1));
    when(
      () => repository.setVersioned(
        'test',
        {'value': 9},
        expectedRevision: 1,
      ),
    ).thenAnswer((_) async => 2);
    final cubit = RemotePreferenceSyncTest(repository);
    await cubit.restoreFromRemote();

    cubit.valueChanged(9);
    await cubit.close();

    verify(
      () => repository.setVersioned(
        'test',
        {'value': 9},
        expectedRevision: 1,
      ),
    ).called(1);
  });

  test('keeps a failed value dirty and retries it explicitly', () async {
    when(() => repository.get('test')).thenAnswer((_) async => _entry(0, 1));
    var calls = 0;
    when(
      () => repository.setVersioned(
        'test',
        {'value': 4},
        expectedRevision: 1,
      ),
    ).thenAnswer((_) async {
      if (calls++ == 0) throw const SetPreferenceFailure('offline');
      return 2;
    });
    final cubit = RemotePreferenceSyncTest(repository);
    await cubit.restoreFromRemote();
    cubit.valueChanged(4);

    await cubit.flushRemotePreferences();
    expect(cubit.statuses.last, RemotePreferenceSyncStatus.offline);
    await cubit.flushRemotePreferences();

    expect(calls, 2);
    expect(cubit.statuses.last, RemotePreferenceSyncStatus.synced);
    await cubit.close();
  });

  test('requires an explicit retry after a CAS conflict', () async {
    var reads = 0;
    when(() => repository.get('test')).thenAnswer(
      (_) async => reads++ == 0 ? _entry(0, 1) : _entry(8, 2),
    );
    var writes = 0;
    when(
      () => repository.setVersioned(
        'test',
        {'value': 5},
        expectedRevision: any(named: 'expectedRevision'),
      ),
    ).thenAnswer((invocation) async {
      if (writes++ == 0) {
        throw const PreferenceConflictFailure('conflict');
      }
      expect(invocation.namedArguments[#expectedRevision], 2);
      return 3;
    });
    final cubit = RemotePreferenceSyncTest(repository);
    await cubit.restoreFromRemote();
    cubit.valueChanged(5);

    await cubit.flushRemotePreferences();

    expect(cubit.state, 5);
    expect(writes, 1);
    expect(cubit.statuses.last, RemotePreferenceSyncStatus.conflict);

    await cubit.flushRemotePreferences();

    expect(writes, 2);
    expect(cubit.statuses.last, RemotePreferenceSyncStatus.synced);
    await cubit.close();
  });

  test('a failing restore hook is reported without blocking close', () async {
    when(() => repository.get('test')).thenAnswer((_) async => _entry(1, 1));
    final cubit = RemotePreferenceSyncTest(
      repository,
      throwOnRestore: true,
    );

    await cubit.restoreFromRemote();
    await cubit.close();

    expect(cubit.isClosed, isTrue);
    expect(cubit.statuses, contains(RemotePreferenceSyncStatus.offline));
  });

  test('close does not silently resolve an outstanding conflict', () async {
    var reads = 0;
    when(() => repository.get('test')).thenAnswer(
      (_) async => reads++ == 0 ? _entry(0, 1) : _entry(8, 2),
    );
    var writes = 0;
    when(
      () => repository.setVersioned(
        'test',
        {'value': 5},
        expectedRevision: any(named: 'expectedRevision'),
      ),
    ).thenAnswer((_) async {
      writes++;
      throw const PreferenceConflictFailure('conflict');
    });
    final cubit = RemotePreferenceSyncTest(repository);
    await cubit.restoreFromRemote();
    cubit.valueChanged(5);

    await cubit.flushRemotePreferences();
    await cubit.close();

    expect(writes, 1);
    expect(cubit.isClosed, isTrue);
  });
}
