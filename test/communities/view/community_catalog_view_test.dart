import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/communities/widgets/saved_community_row.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../../helpers/pump_app.dart';

class _CatalogCubit extends MockCubit<CommunityCatalogState>
    implements CommunityCatalogCubit {}

class _SavedCubit extends MockCubit<List<String>>
    implements JoinedCommunitiesCubit {}

void main() {
  late CommunityCatalogCubit cubit;
  late JoinedCommunitiesCubit saved;
  const entry = CommunityCatalogEntry(
    id: 'entry-1',
    slug: 'robotics',
    title: 'Robotics club',
    description: 'Build robots together',
    url: 'https://t.me/robotics',
    platform: 'telegram',
    membersCount: 25,
  );
  const catalog = CommunityCatalog(
    organizationId: 'university',
    sections: [
      CommunityCatalogSection(
        key: 'clubs',
        title: 'Clubs',
        emoji: '🤖',
        items: [entry],
      ),
    ],
  );

  setUp(() {
    cubit = _CatalogCubit();
    saved = _SavedCubit();
    when(() => saved.state).thenReturn([]);
    when(() => saved.isJoined(any())).thenReturn(false);
    when(() => saved.toggle(any())).thenReturn(null);
    when(
      () => cubit.load(locale: any(named: 'locale')),
    ).thenAnswer((_) async {});
    when(() => cubit.queryChanged(any())).thenReturn(null);
    when(() => cubit.sectionSelected(any())).thenReturn(null);
  });

  Widget subject(CommunityCatalogState state) {
    when(() => cubit.state).thenReturn(state);
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommunityCatalogCubit>.value(value: cubit),
        BlocProvider<JoinedCommunitiesCubit>.value(value: saved),
      ],
      child: AllCommunitiesView(key: ValueKey(state)),
    );
  }

  testWidgets('cold load renders one skeleton scene', (tester) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .loading)),
    );
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
    expect(find.byType(NinjaEmptyState), findsNothing);
  });

  testWidgets('cold load fits 320px at 200 percent text', (tester) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .loading)),
      size: const Size(320, 800),
      textScaler: const TextScaler.linear(2),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('catalog fits 320px at 200 percent text', (tester) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .success, catalog: catalog)),
      size: const Size(320, 800),
      textScaler: const TextScaler.linear(2),
    );
    expect(find.byType(AppChipRow<String?>), findsOneWidget);
    expect(find.byType(AppSearchBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cold error retries through repository cubit', (tester) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .failure)),
    );
    await tester.tap(find.text('Повторить'));
    verify(() => cubit.load(locale: 'ru')).called(1);
  });

  testWidgets('stale refresh preserves loaded catalog', (tester) async {
    await tester.pumpApp(
      subject(
        const CommunityCatalogState(
          status: .success,
          catalog: catalog,
          isRefreshing: true,
        ),
      ),
    );
    expect(find.text('Robotics club'), findsOneWidget);
    expect(find.byType(AppProgressBar), findsOneWidget);
    expect(find.byType(NinjaErrorState), findsNothing);
  });

  testWidgets('successful empty response renders empty state', (tester) async {
    await tester.pumpApp(
      subject(
        const CommunityCatalogState(
          status: .success,
          catalog: CommunityCatalog(organizationId: 'university', sections: []),
        ),
      ),
    );
    expect(find.byType(NinjaEmptyState), findsOneWidget);
    expect(find.byType(NinjaSkeletonGroup), findsNothing);
  });

  testWidgets('empty filtered result clears both filters', (tester) async {
    await tester.pumpApp(
      subject(
        const CommunityCatalogState(
          status: .success,
          query: 'none',
          selectedSectionKey: 'clubs',
          catalog: catalog,
        ),
      ),
    );
    final empty = tester.widget<NinjaEmptyState>(find.byType(NinjaEmptyState));
    empty.onAction!();
    verify(() => cubit.queryChanged('')).called(1);
    verify(() => cubit.sectionSelected(null)).called(1);
  });

  testWidgets('header retains accessible circular back action', (tester) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .loading)),
    );
    final back = find.bySemanticsLabel('Назад');
    expect(back, findsOneWidget);
    expect(tester.getSize(back).height, greaterThanOrEqualTo(44));
  });

  testWidgets('search and category selection forward to cubit', (tester) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .success, catalog: catalog)),
    );
    await tester.ensureVisible(find.text('Поиск'));
    await tester.tap(find.text('Поиск'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'robot');
    verify(() => cubit.queryChanged('robot')).called(1);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AppChipRow<String?>),
        matching: find.text('Clubs'),
      ),
    );
    verify(() => cubit.sectionSelected('clubs')).called(1);
  });

  testWidgets('suggestion action exists only for configured safe URL', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .success, catalog: catalog)),
    );
    expect(find.bySemanticsLabel('Предложить сообщество'), findsNothing);
    await tester.pumpApp(
      subject(
        CommunityCatalogState(
          status: .success,
          catalog: catalog.copyWith(suggestionUrl: 'https://t.me/suggest'),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Предложить сообщество'), findsOneWidget);
  });

  testWidgets('save is local and does not inflate real member counts', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .success, catalog: catalog)),
    );
    await tester.ensureVisible(find.text('В мои'));
    await tester.tap(find.text('В мои'));
    verify(() => saved.toggle('entry-1')).called(1);
    expect(
      communityMembers(
        tester.element(find.byType(AllCommunitiesView)).l10n,
        entry,
        joined: true,
      ),
      '25 участников',
    );
  });

  testWidgets('catalog opens real community details', (tester) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .success, catalog: catalog)),
    );
    await tester.tap(find.text('Robotics club'));
    await tester.pumpAndSettle();
    expect(find.byType(CommunityDetailPage), findsOneWidget);
    expect(find.text('Build robots together'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Открыть чат'), findsOneWidget);
  });

  test('platform parsing and URL validation reject misleading schemes', () {
    expect(
      communityPlatformFor(Uri.parse('https://t.me/example')),
      CommunityPlatform.telegram,
    );
    expect(
      communityPlatformFor(Uri.parse('https://evil.example/?next=t.me')),
      CommunityPlatform.web,
    );
    expect(safeCommunityUri('http://t.me/example'), isNull);
    expect(safeCommunityUri('javascript:alert(1)'), isNull);
    expect(safeCommunityUri('https://user@t.me/example'), isNull);
  });

  testWidgets('community details preserve local saving at 320px and 200%', (
    tester,
  ) async {
    await tester.pumpApp(
      BlocProvider<JoinedCommunitiesCubit>.value(
        value: saved,
        child: const CommunityDetailPage(entry: entry, categoryTitle: 'Clubs'),
      ),
      size: const Size(320, 844),
      textScaler: const TextScaler.linear(2),
    );
    await tester.ensureVisible(find.text('В мои'));
    await tester.tap(find.text('В мои'));
    verify(() => saved.toggle('entry-1')).called(1);
    await tester.ensureVisible(find.text('участников'));
    expect(find.text('25'), findsOneWidget);
    expect(find.text('2'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saved communities are not recommended but remain searchable', (
    tester,
  ) async {
    when(() => saved.isJoined('entry-1')).thenReturn(true);
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .success, catalog: catalog)),
    );
    expect(find.byType(SavedCommunityRow), findsOneWidget);
    expect(find.byType(CommunityCard), findsNothing);

    await tester.pumpApp(
      subject(
        const CommunityCatalogState(
          status: .success,
          catalog: catalog,
          query: 'robotics',
        ),
      ),
    );
    expect(find.byType(CommunityCard), findsOneWidget);
    await tester.pumpApp(
      subject(
        const CommunityCatalogState(
          status: .success,
          catalog: catalog,
          selectedSectionKey: 'clubs',
        ),
      ),
    );
    expect(find.byType(CommunityCard), findsOneWidget);
    expect(find.byType(SavedCommunityRow), findsOneWidget);
  });
}
