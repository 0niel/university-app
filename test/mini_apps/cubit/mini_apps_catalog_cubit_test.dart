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

      test(
        'keeps the newest full response when an older load finishes last',
        () async {
          const newestApp = MiniApp(id: 'new', slug: 'new', name: 'New');
          final olderOwnedApps = Completer<List<MiniApp>>();
          var calls = 0;
          when(repository.getMyApps).thenAnswer((_) {
            calls++;
            return calls == 1
                ? olderOwnedApps.future
                : Future.value(const [newestApp]);
          });
          var moderatorCalls = 0;
          when(repository.isModerator).thenAnswer((_) async {
            moderatorCalls++;
            return moderatorCalls > 1;
          });
          var recentCalls = 0;
          when(
            () => repository.getRecentApps(limit: any(named: 'limit')),
          ).thenAnswer((_) async {
            recentCalls++;
            return recentCalls == 1 ? const [app] : const [newestApp];
          });
          final cubit = buildCubit();
          addTearDown(cubit.close);

          final olderRequest = cubit.load();
          await cubit.load();
          final newestState = cubit.state;
          olderOwnedApps.complete(const [myApp]);
          await olderRequest;

          expect(cubit.state, newestState);
          expect(cubit.state.myApps, const [newestApp]);
          expect(cubit.state.recents, const [newestApp]);
          expect(cubit.state.isModerator, isTrue);
        },
      );

      test(
        'loads account sections without replacing a newer search result',
        () async {
          const matchingApp = MiniApp(
            id: 'match',
            slug: 'match',
            name: 'Match',
          );
          final ownedApps = Completer<List<MiniApp>>();
          when(repository.getMyApps).thenAnswer((_) => ownedApps.future);
          when(
            () => repository.getApps(query: 'match'),
          ).thenAnswer((_) async => const [matchingApp]);
          final cubit = buildCubit();
          addTearDown(cubit.close);

          final initialLoad = cubit.load();
          await cubit.queryChanged('match');
          ownedApps.complete(const [myApp]);
          await initialLoad;

          expect(cubit.state.status, MiniAppsCatalogStatus.populated);
          expect(cubit.state.query, 'match');
          expect(cubit.state.apps, const [matchingApp]);
          expect(cubit.state.myApps, const [myApp]);
          expect(cubit.state.isModerator, isTrue);
        },
      );

      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'preserves loaded content during a failed refresh',
        setUp: () => when(
          () => repository.getApps(),
        ).thenThrow(const GetMiniAppsFailure('offline')),
        build: buildCubit,
        seed: () => const MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          apps: [app],
          myApps: [myApp],
          recents: [app],
        ),
        act: (cubit) => cubit.load(),
        expect: () => const [
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.loading,
            apps: [app],
            myApps: [myApp],
            recents: [app],
          ),
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.failure,
            apps: [app],
            myApps: [myApp],
            recents: [app],
          ),
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
            status: MiniAppsCatalogStatus.loading,
          ),
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

      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'preserves cards while searching and ignores an unchanged query',
        build: buildCubit,
        seed: () => const MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          apps: [app],
          myApps: [myApp],
        ),
        act: (cubit) async {
          await cubit.queryChanged(' poll ');
          await cubit.queryChanged('poll');
        },
        expect: () => const [
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.populated,
            apps: [app],
            myApps: [myApp],
            query: 'poll',
          ),
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.loading,
            apps: [app],
            myApps: [myApp],
            query: 'poll',
          ),
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.populated,
            apps: [app],
            myApps: [myApp],
            query: 'poll',
          ),
        ],
        verify: (_) => verify(
          () => repository.getApps(query: 'poll'),
        ).called(1),
      );
    });

    group('filters', () {
      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'resets query and category together with one refetch',
        build: buildCubit,
        seed: () => const MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          apps: [app],
          query: 'poll',
          category: MiniAppCategory.study,
          sort: MiniAppSort.top,
          isSearching: true,
        ),
        act: (cubit) => cubit.resetFilters(),
        expect: () => const [
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.populated,
            apps: [app],
            sort: MiniAppSort.top,
            isSearching: true,
          ),
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.loading,
            apps: [app],
            sort: MiniAppSort.top,
            isSearching: true,
          ),
          MiniAppsCatalogState(
            status: MiniAppsCatalogStatus.populated,
            apps: [app],
            sort: MiniAppSort.top,
            isSearching: true,
          ),
        ],
        verify: (_) => verify(
          () => repository.getApps(sort: MiniAppSort.top),
        ).called(1),
      );

      blocTest<MiniAppsCatalogCubit, MiniAppsCatalogState>(
        'unchanged query, category, sort and reset do not refetch',
        build: buildCubit,
        act: (cubit) async {
          await cubit.queryChanged('  ');
          await cubit.categoryChanged(null);
          await cubit.sortChanged(MiniAppSort.popular);
          await cubit.resetFilters();
        },
        expect: () => const <MiniAppsCatalogState>[],
        verify: (_) => verifyNever(
          () => repository.getApps(
            query: any(named: 'query'),
            category: any(named: 'category'),
            sort: any(named: 'sort'),
            includeHidden: any(named: 'includeHidden'),
          ),
        ),
      );

      test(
        'closing search invalidates its pending results and keeps category',
        () async {
          final pendingQuery = Completer<List<MiniApp>>();
          when(
            () => repository.getApps(
              query: 'poll',
              category: MiniAppCategory.study,
            ),
          ).thenAnswer((_) => pendingQuery.future);
          final cubit = buildCubit();
          addTearDown(cubit.close);
          await cubit.categoryChanged(MiniAppCategory.study);
          await cubit.searchToggled();
          final queryRequest = cubit.queryChanged('poll');
          await cubit.searchToggled();
          final closedSearch = cubit.state;
          pendingQuery.complete(const []);
          await queryRequest;

          expect(cubit.state, closedSearch);
          expect(cubit.state.isSearching, isFalse);
          expect(cubit.state.query, isEmpty);
          expect(cubit.state.category, MiniAppCategory.study);
          expect(cubit.state.apps, const [app]);
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
            status: MiniAppsCatalogStatus.loading,
          ),
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

    group('lifecycle', () {
      test('ignores a full load response after close', () async {
        final pending = Completer<List<MiniApp>>();
        when(() => repository.getApps()).thenAnswer((_) => pending.future);
        final cubit = buildCubit();
        final request = cubit.load();
        await cubit.close();
        final closedState = cubit.state;
        pending.complete(const [app]);
        await request;

        expect(cubit.state, closedState);
      });

      test('ignores a failed search response after close', () async {
        final pending = Completer<List<MiniApp>>();
        when(
          () => repository.getApps(query: 'poll'),
        ).thenAnswer((_) => pending.future);
        final cubit = buildCubit();
        final request = cubit.queryChanged('poll');
        await cubit.close();
        final closedState = cubit.state;
        pending.completeError(
          const GetMiniAppsFailure('offline'),
          StackTrace.current,
        );
        await request;

        expect(cubit.state, closedState);
      });

      test('does not start requests or change filters after close', () async {
        final cubit = buildCubit();
        await cubit.close();
        await cubit.load();
        await cubit.queryChanged('poll');
        await cubit.categoryChanged(MiniAppCategory.study);
        await cubit.sortChanged(MiniAppSort.top);
        await cubit.resetFilters();
        await cubit.searchToggled();
        await cubit.toggleFeatured(app);
        await cubit.setHidden(app, hidden: true);
        await cubit.rate(app, 5);
        await cubit.setConsents(app, const []);
        await cubit.deleteMyApp(myApp);
        final reported = await cubit.report(app, MiniAppReportReason.spam, '');

        expect(cubit.state, const MiniAppsCatalogState());
        expect(reported, isFalse);
        verifyZeroInteractions(repository);
      });

      test('ignores a mutation response after close', () async {
        final pending = Completer<void>();
        when(
          () => repository.setHidden(appId: app.id, hidden: true),
        ).thenAnswer((_) => pending.future);
        final cubit = buildCubit();
        await cubit.load();
        final request = cubit.setHidden(app, hidden: true);
        await cubit.close();
        final closedState = cubit.state;
        pending.complete();
        await request;

        expect(cubit.state, closedState);
      });
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
          MiniAppsCatalogState(status: MiniAppsCatalogStatus.loading),
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
