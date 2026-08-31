import 'package:mocktail/mocktail.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

class PreferencesRepositoryTestRemote extends Mock
    implements RemotePreferencesDataSource {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

void main() {
  late RemotePreferencesDataSource remote;
  late GoTrueClient auth;
  late PreferencesRepository repository;

  setUp(() {
    remote = PreferencesRepositoryTestRemote();
    auth = MockGoTrueClient();
    repository = PreferencesRepository.fromDataSources(
      auth: auth,
      remote: remote,
    );
  });

  test('get loads only the requested preference', () async {
    final entry = UserPreferenceEntry(
      key: 'schedule',
      value: const {'enabled': true},
      revision: 3,
      updatedAt: DateTime.utc(2026),
    );
    when(() => remote.get('schedule')).thenAnswer((_) async => entry);

    expect(await repository.get('schedule'), entry);
    verify(() => remote.get('schedule')).called(1);
    verifyNever(remote.getAll);
  });

  test('setVersioned returns the server revision', () async {
    when(
      () => remote.set(
        'schedule',
        const {'enabled': true},
        expectedRevision: 2,
      ),
    ).thenAnswer((_) async => 3);

    expect(
      await repository.setVersioned(
        'schedule',
        const {'enabled': true},
        expectedRevision: 2,
      ),
      3,
    );
  });

  test('setVersioned maps revision conflicts to a domain failure', () async {
    when(
      () => remote.set(
        'schedule',
        const {'enabled': true},
        expectedRevision: 2,
      ),
    ).thenThrow(const PreferenceRevisionConflictException());

    expect(
      () => repository.setVersioned(
        'schedule',
        const {'enabled': true},
        expectedRevision: 2,
      ),
      throwsA(isA<PreferenceConflictFailure>()),
    );
  });

  test('UserPreferenceEntry rejects missing protocol fields', () {
    expect(
      () => UserPreferenceEntry.fromJson(const {
        'key': 'schedule',
        'value': <String, dynamic>{},
      }),
      throwsA(anything),
    );
  });

  test('hasAuthenticatedUser reflects the auth session', () {
    when(() => auth.currentUser).thenReturn(MockUser());
    expect(repository.hasAuthenticatedUser, isTrue);
    when(() => auth.currentUser).thenReturn(null);
    expect(repository.hasAuthenticatedUser, isFalse);
  });
}
