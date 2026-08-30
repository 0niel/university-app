import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';

class MockMiniAppsRepository extends Mock implements MiniAppsRepository {}

void main() {
  const app = MiniApp(
    id: 'app-1',
    slug: 'poll',
    name: 'Опросы',
    status: MiniAppStatus.published,
  );
  const myApp = MiniApp(
    id: 'app-2',
    slug: 'mine',
    name: 'Мой апп',
    isOwner: true,
  );

  group('MiniAppsCatalogCubit', () {
    late MiniAppsRepository repository;

    setUpAll(() {
      registerFallbackValue(MiniAppReportReason.other);
      registerFallbackValue(MiniAppSort.popular);
    });

    setUp(() {
      repository = MockMiniAppsRepository();
      when(
        () => repository.getApps(
          query: any(named: 'query'),
          category: any(named: 'category'),
          sort: any(named: 'sort'),
          includeHidden: any(named: 'includeHidden'),
        ),
      ).thenAnswer((_) async => [app]);
      when(repository.getMyApps).thenAnswer((_) async => [myApp]);
      when(repository.isModerator).thenAnswer((_) async => true);
      when(
        () => repository.getRecentApps(limit: any(named: 'limit')),
      ).thenAnswer((_) async => const []);
    });

    MiniAppsCatalogCubit buildCubit() =>
        MiniAppsCatalogCubit(miniAppsRepository: repository);

    test('initial state is MiniAppsCatalogState with initial status', () {
      expect(buildCubit().state, equals(const MiniAppsCatalogState()));
    });

    group('load', () {
      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'emits [loading, populated] with apps, my apps and moderator flag',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppsCatalogState>[
          MiniAppsCatalogState(status: MiniAppsCatalogStatus.loading),
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.populated,
            apps: [app],
            myApps: [myApp],
            isModerator: true,
          ),
        ],
      );

      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'emits [loading, failure] when the catalog request fails',
        setUp: () =>
            when(
              () => repository.getApps(
                query: any(named: 'query'),
                category: any(named: 'category'),
                sort: any(named: 'sort'),
                includeHidden: any(named: 'includeHidden'),
              ),
            ).thenAnswer(
              (_) async => throw const GetMiniAppsFailure('boom'),
            ),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppsCatalogState>[
          MiniAppsCatalogState(status: MiniAppsCatalogStatus.loading),
          MiniAppsCatalogState(status: MiniAppsCatalogStatus.failure),
        ],
        errors: () => [isA<GetMiniAppsFailure>()],
      );
    });

    group('queryChanged', () {
      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'stores the query and refetches from the server',
        build: buildCubit,
        act: (cubit) => cubit.queryChanged('гороскоп'),
        expect: () => const <MiniAppsCatalogState>[
          MiniAppsCatalogState(query: 'гороскоп'),
          MiniAppsCatalogState(
            query: 'гороскоп',
            status: MiniAppsCatalogStatus.populated,
            apps: [app],
          ),
        ],
        verify: (_) => verify(
          () => repository.getApps(
            query: 'гороскоп',
          ),
        ).called(1),
      );

      test(
        'keeps the newest result when an older query finishes last',
        () async {
          const olderApp = MiniApp(id: 'old', slug: 'old', name: 'Old');
          const newerApp = MiniApp(id: 'new', slug: 'new', name: 'New');
          final older = Completer<List<MiniApp>>();
          final newer = Completer<List<MiniApp>>();
          when(
            () => repository.getApps(
              query: any(named: 'query'),
              category: any(named: 'category'),
              sort: any(named: 'sort'),
              includeHidden: any(named: 'includeHidden'),
            ),
          ).thenAnswer((invocation) {
            final query = invocation.namedArguments[#query];
            return query == 'old' ? older.future : newer.future;
          });
          final cubit = buildCubit();

          final olderRequest = cubit.queryChanged('old');
          await Future<void>.delayed(Duration.zero);
          final newerRequest = cubit.queryChanged('new');
          newer.complete(const [newerApp]);
          await newerRequest;
          older.complete(const [olderApp]);
          await olderRequest;

          expect(cubit.state.query, 'new');
          expect(cubit.state.apps, const [newerApp]);
          await cubit.close();
        },
      );
    });

    group('sortChanged', () {
      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'stores the sort order and refetches with it',
        build: buildCubit,
        act: (cubit) => cubit.sortChanged(MiniAppSort.top),
        expect: () => const <MiniAppsCatalogState>[
          MiniAppsCatalogState(sort: MiniAppSort.top),
          MiniAppsCatalogState(
            sort: MiniAppSort.top,
            status: MiniAppsCatalogStatus.populated,
            apps: [app],
          ),
        ],
        verify: (_) => verify(
          () => repository.getApps(
            sort: MiniAppSort.top,
          ),
        ).called(1),
      );
    });

    group('toggleFeatured', () {
      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'features the app and refetches the catalog',
        setUp: () => when(
          () => repository.setFeatured(
            appId: any(named: 'appId'),
            featured: any(named: 'featured'),
          ),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        act: (cubit) => cubit.toggleFeatured(app),
        expect: () => const <MiniAppsCatalogState>[
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.populated,
            apps: [app],
          ),
        ],
        verify: (_) => verify(
          () => repository.setFeatured(appId: 'app-1', featured: true),
        ).called(1),
      );

      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'reports the error when the toggle fails',
        setUp: () => when(
          () => repository.setFeatured(
            appId: any(named: 'appId'),
            featured: any(named: 'featured'),
          ),
        ).thenThrow(const SetMiniAppFeaturedFailure('boom')),
        build: buildCubit,
        act: (cubit) => cubit.toggleFeatured(app),
        expect: () => const <MiniAppsCatalogState>[],
        errors: () => [isA<SetMiniAppFeaturedFailure>()],
      );
    });

    group('setConsents', () {
      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'stores the decision and updates the catalog row',
        setUp: () => when(
          () => repository.setConsents(
            appId: any(named: 'appId'),
            scopes: any(named: 'scopes'),
          ),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        seed: () => const MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          apps: [app],
        ),
        act: (cubit) => cubit.setConsents(app, const [MiniAppPermission.email]),
        expect: () => [
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.populated,
            apps: [
              app.copyWith(
                grantedPermissions: const [MiniAppPermission.email],
              ),
            ],
          ),
        ],
      );
    });

    group('setHidden', () {
      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'removes a freshly hidden app from the visible catalog',
        setUp: () => when(
          () => repository.setHidden(
            appId: any(named: 'appId'),
            hidden: any(named: 'hidden'),
          ),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        seed: () => const MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          apps: [app],
        ),
        act: (cubit) => cubit.setHidden(app, hidden: true),
        expect: () => const <MiniAppsCatalogState>[
          MiniAppsCatalogState(status: MiniAppsCatalogStatus.populated),
        ],
      );
    });

    group('report', () {
      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'marks the app as reported when the request succeeds',
        setUp: () => when(
          () => repository.reportApp(
            appId: any(named: 'appId'),
            reason: any(named: 'reason'),
            details: any(named: 'details'),
          ),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        seed: () => const MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          apps: [app],
        ),
        act: (cubit) => cubit.report(app, MiniAppReportReason.spam, 'реклама'),
        expect: () => [
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.populated,
            apps: [app.copyWith(hasMyOpenReport: true)],
          ),
        ],
      );

      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'keeps state and reports the error when the request fails',
        setUp: () => when(
          () => repository.reportApp(
            appId: any(named: 'appId'),
            reason: any(named: 'reason'),
            details: any(named: 'details'),
          ),
        ).thenThrow(const ReportMiniAppFailure('boom')),
        build: buildCubit,
        seed: () => const MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          apps: [app],
        ),
        act: (cubit) => cubit.report(app, MiniAppReportReason.spam, 'реклама'),
        expect: () => const <MiniAppsCatalogState>[],
        errors: () => [isA<ReportMiniAppFailure>()],
      );
    });
  });
}
