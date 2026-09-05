import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storage/storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide StorageException;

import 'fakes/fake_storage.dart';
import 'mocks/mock_supabase_client.dart';

void main() {
  late SupabaseClient supabase;
  late GoTrueClient auth;
  late FunctionsClient functions;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(const FileOptions());
  });

  setUp(() {
    supabase = MockSupabaseClient();
    auth = MockGoTrueClient();
    functions = MockFunctionsClient();
    when(() => supabase.auth).thenReturn(auth);
    when(() => supabase.functions).thenReturn(functions);
    when(() => auth.currentUser).thenReturn(
      const User(
        id: 'user-a',
        appMetadata: {},
        userMetadata: {},
        aud: 'authenticated',
        createdAt: '',
      ),
    );
  });

  MiniAppsRepository buildRepository({Storage? cache}) => MiniAppsRepository(
    supabase: supabase,
    organizationId: 'mirea',
    cache: cache,
  );

  group('screen cache', () {
    test('readCachedScreen returns what fetchScreen stored', () async {
      final cache = FakeStorage();
      cache.values['mini_app_screen.user-a.poll./'] = '{"type":"scaffold"}';
      final repository = buildRepository(cache: cache);

      expect(
        await repository.readCachedScreen(slug: 'poll'),
        {'type': 'scaffold'},
      );
      expect(
        await repository.readCachedScreen(slug: 'poll', path: '/x'),
        isNull,
      );
    });

    test('a corrupted cache entry behaves like a miss', () async {
      final cache = FakeStorage();
      cache.values['mini_app_screen.user-a.poll./'] = 'not json at all';
      cache.values['mini_app_storage.user-a.app-1'] = '[1, 2, 3]';
      final repository = buildRepository(cache: cache);

      expect(await repository.readCachedScreen(slug: 'poll'), isNull);
      expect(await repository.readCachedStorage('app-1'), isNull);
    });

    test('a failing store never throws out of cache reads', () async {
      final repository = buildRepository(cache: FakeStorage(failing: true));
      expect(await repository.readCachedScreen(slug: 'poll'), isNull);
    });

    test('without a cache reads are simple misses', () async {
      final repository = buildRepository();
      expect(await repository.readCachedScreen(slug: 'poll'), isNull);
      expect(await repository.readCachedStorage('app-1'), isNull);
    });

    test('does not expose another account cache', () async {
      final cache = FakeStorage();
      cache.values['mini_app_screen.user-a.poll./'] = '{"owner":"a"}';
      final repository = buildRepository(cache: cache);

      when(() => auth.currentUser).thenReturn(
        const User(
          id: 'user-b',
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: '',
        ),
      );

      expect(await repository.readCachedScreen(slug: 'poll'), isNull);
    });

    test('does not read cache while signed out', () async {
      final cache = FakeStorage();
      when(() => auth.currentUser).thenReturn(null);
      final repository = buildRepository(cache: cache);

      expect(await repository.readCachedScreen(slug: 'poll'), isNull);
      expect(cache.values, isEmpty);
    });

    test('does not cache a screen after the account changes', () async {
      final cache = FakeStorage();
      final response = Completer<FunctionResponse>();
      when(
        () => functions.invoke(
          'miniapp-proxy',
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) => response.future);
      final repository = buildRepository(cache: cache);

      final request = repository.fetchScreen(slug: 'poll');
      await Future<void>.delayed(Duration.zero);
      when(() => auth.currentUser).thenReturn(
        const User(
          id: 'user-b',
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: '',
        ),
      );
      response.complete(
        FunctionResponse(status: 200, data: const {'owner': 'a'}),
      );

      await expectLater(request, throwsA(isA<FetchMiniAppScreenFailure>()));
      expect(cache.values, isEmpty);
    });
  });

  group('image upload', () {
    late SupabaseStorageClient storage;
    late StorageFileApi bucket;

    setUp(() {
      storage = MockSupabaseStorageClient();
      bucket = MockStorageFileApi();
      when(() => supabase.storage).thenReturn(storage);
      when(() => storage.from('mini-app-uploads')).thenReturn(bucket);
      when(
        () => bucket.uploadBinary(
          any(),
          any(),
          fileOptions: any(named: 'fileOptions'),
        ),
      ).thenAnswer((_) async => 'uploaded');
      when(() => bucket.getPublicUrl(any())).thenReturn(
        'https://example.test/photo',
      );
    });

    for (final (extension, mime, signature) in [
      ('jpg', 'image/jpeg', [0xff, 0xd8, 0xff, 0xe0]),
      ('png', 'image/png', [0x89, 0x50, 0x4e, 0x47, 13, 10, 26, 10]),
      ('webp', 'image/webp', [82, 73, 70, 70, 0, 0, 0, 0, 87, 69, 66, 80]),
    ]) {
      test(
        'detects $extension from bytes instead of file metadata',
        () async {
          final bytes = Uint8List.fromList(signature);
          final url = await buildRepository().uploadImage(
            appId: 'app-1',
            bytes: bytes,
            fileName: 'camera-file.heic',
            contentType: 'application/octet-stream',
          );

          final captured = verify(
            () => bucket.uploadBinary(
              captureAny(),
              bytes,
              fileOptions: captureAny(named: 'fileOptions'),
            ),
          ).captured;
          expect(captured[0], startsWith('user-a/app-1/'));
          expect(captured[0], endsWith('.$extension'));
          final options = captured[1] as FileOptions;
          expect(options.contentType, mime);
          expect(options.upsert, isFalse);
          expect(url, 'https://example.test/photo');
        },
      );
    }

    test('rejects unsupported bytes before starting an upload', () async {
      await expectLater(
        buildRepository().uploadImage(
          appId: 'app-1',
          bytes: Uint8List.fromList([1, 2, 3, 4]),
          contentType: 'image/jpeg',
        ),
        throwsA(isA<MiniAppUploadFailure>()),
      );

      verifyNever(() => storage.from(any()));
    });
  });

  group('failure wrapping', () {
    void stubRpcThrow() {
      when(
        () => supabase.rpc<Object?>(any(), params: any(named: 'params')),
      ).thenThrow(const PostgrestException(message: 'boom'));
      when(() => supabase.rpc<Object?>(any())).thenThrow(
        const PostgrestException(message: 'boom'),
      );
    }

    setUp(stubRpcThrow);

    test('getApps wraps into GetMiniAppsFailure', () {
      expect(
        () => buildRepository().getApps(),
        throwsA(isA<GetMiniAppsFailure>()),
      );
    });

    test('submitApp wraps into SubmitMiniAppFailure', () {
      expect(
        () => buildRepository().submitApp(slug: 's', name: 'n'),
        throwsA(isA<SubmitMiniAppFailure>()),
      );
    });

    test('setConsents wraps into SetMiniAppConsentsFailure', () {
      expect(
        () => buildRepository().setConsents(appId: 'a', scopes: const []),
        throwsA(isA<SetMiniAppConsentsFailure>()),
      );
    });

    test('storage ops wrap into MiniAppStorageFailure', () {
      expect(
        () => buildRepository().getStorage('a'),
        throwsA(isA<MiniAppStorageFailure>()),
      );
      expect(
        () => buildRepository().setStorageValue(appId: 'a', key: 'k'),
        throwsA(isA<MiniAppStorageFailure>()),
      );
    });

    test('revisions ops wrap into MiniAppRevisionsFailure', () {
      expect(
        () => buildRepository().getRevisions('a'),
        throwsA(isA<MiniAppRevisionsFailure>()),
      );
      expect(
        () => buildRepository().restoreRevision(appId: 'a', version: 1),
        throwsA(isA<MiniAppRevisionsFailure>()),
      );
    });

    test('deploy token ops wrap into MiniAppDeployTokenFailure', () {
      expect(
        () => buildRepository().createDeployToken(),
        throwsA(isA<MiniAppDeployTokenFailure>()),
      );
      expect(
        () => buildRepository().listDeployTokens(),
        throwsA(isA<MiniAppDeployTokenFailure>()),
      );
    });

    test('signing secret ops wrap into MiniAppSigningSecretFailure', () {
      expect(
        () => buildRepository().getSigningSecretInfo('a'),
        throwsA(isA<MiniAppSigningSecretFailure>()),
      );
      expect(
        () => buildRepository().rotateSigningSecret('a'),
        throwsA(isA<MiniAppSigningSecretFailure>()),
      );
      expect(
        () => buildRepository().revokeSigningSecret('a'),
        throwsA(isA<MiniAppSigningSecretFailure>()),
      );
    });

    test('uploadImage/uploadFile wrap into MiniAppUploadFailure', () {
      when(() => supabase.auth).thenThrow(Exception('no auth'));
      expect(
        () => buildRepository().uploadImage(appId: 'a', bytes: Uint8List(0)),
        throwsA(isA<MiniAppUploadFailure>()),
      );
      expect(
        () => buildRepository().uploadFile(
          appId: 'a',
          bytes: Uint8List(0),
          fileName: 'd.pdf',
        ),
        throwsA(isA<MiniAppUploadFailure>()),
      );
    });

    test('validateScreens wraps into ValidateMiniAppScreensFailure', () {
      expect(
        () => buildRepository().validateScreens(const []),
        throwsA(isA<ValidateMiniAppScreensFailure>()),
      );
    });

    test('setFeatured wraps into SetMiniAppFeaturedFailure', () {
      expect(
        () => buildRepository().setFeatured(appId: 'a', featured: true),
        throwsA(isA<SetMiniAppFeaturedFailure>()),
      );
    });

    test('trackLaunch swallows errors (analytics must not break runs)', () {
      expect(buildRepository().trackLaunch('a'), completes);
    });

    test('isModerator degrades to false on errors', () async {
      expect(await buildRepository().isModerator(), isFalse);
    });
  });
}
