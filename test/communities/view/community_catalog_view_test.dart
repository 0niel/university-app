import 'package:app_ui/app_ui.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/communities/communities.dart';

import '../../helpers/pump_app.dart';

final class CommunityCatalogViewTest extends Mock
    implements CommunityCatalogCubit {}

void main() {
  late CommunityCatalogCubit cubit;

  const entry = CommunityCatalogEntry(
    id: 'entry-1',
    slug: 'robotics',
    title: 'Robotics club',
    description: 'Build robots together',
    url: 'https://t.me/robotics',
    platform: 'telegram',
    isFeatured: true,
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
    cubit = CommunityCatalogViewTest();
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(
      () => cubit.load(locale: any(named: 'locale')),
    ).thenAnswer((_) => Future.value());
    when(() => cubit.queryChanged(any())).thenReturn(null);
    when(() => cubit.sectionSelected(any())).thenReturn(null);
  });

  Widget subject(CommunityCatalogState state) {
    when(() => cubit.state).thenReturn(state);
    return BlocProvider.value(
      value: cubit,
      child: const AllCommunitiesView(),
    );
  }

  testWidgets('shows skeleton only during a cold load', (tester) async {
    await tester.pumpApp(
      subject(
        const CommunityCatalogState(status: .loading),
      ),
    );

    expect(find.byType(NinjaCommunityCatalogSkeleton), findsOneWidget);
    expect(find.byType(NinjaEmptyState), findsNothing);
  });

  testWidgets('cold-load composition fits 320px at 200% text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .loading)),
    );

    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
    expect(find.byType(NinjaSkeleton), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('catalog chrome fits 320px at 200% text', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .success, catalog: catalog)),
    );

    expect(find.byType(NinjaCommunitySectionFilters), findsOneWidget);
    expect(find.byType(NinjaInput), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a truthful error and retries', (tester) async {
    await tester.pumpApp(
      subject(
        const CommunityCatalogState(status: .failure),
      ),
    );

    expect(find.byType(NinjaErrorState), findsOneWidget);
    await tester.tap(find.text('Повторить'));

    verify(() => cubit.load(locale: 'ru')).called(1);
  });

  testWidgets('keeps catalog visible during stale refresh', (tester) async {
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
    expect(find.byType(NinjaProgressBar), findsOneWidget);
    expect(find.byType(NinjaErrorState), findsNothing);
  });

  testWidgets('shows empty state only after successful empty response', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(
        const CommunityCatalogState(
          status: .success,
          catalog: CommunityCatalog(
            organizationId: 'university',
            sections: [],
          ),
        ),
      ),
    );

    expect(find.byType(NinjaEmptyState), findsOneWidget);
    expect(find.byType(NinjaCommunityCatalogSkeleton), findsNothing);
  });

  testWidgets('empty state resets the filters through its pill action', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(
        const CommunityCatalogState(
          status: .success,
          query: 'robots',
          selectedSectionKey: 'clubs',
          catalog: CommunityCatalog(
            organizationId: 'university',
            sections: [],
          ),
        ),
      ),
    );

    final emptyState = tester.widget<NinjaEmptyState>(
      find.byType(NinjaEmptyState),
    );
    expect(emptyState.actionLabel, isNotNull);
    await tester.tap(find.text(emptyState.actionLabel!));
    await tester.pump();

    verify(() => cubit.queryChanged('')).called(1);
    verify(() => cubit.sectionSelected(null)).called(1);
  });

  testWidgets('catalog header carries a 44dp circular back button', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(const CommunityCatalogState(status: .success, catalog: catalog)),
    );

    final back = find.descendant(
      of: find.byType(NinjaCommunityCatalogHeader),
      matching: find.byType(NinjaIconButton),
    );
    expect(back, findsOneWidget);
    expect(tester.getSize(back), const Size(44, 44));
  });

  testWidgets('collapses the catalog chrome and keeps search pinned', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final longCatalog = CommunityCatalog(
      organizationId: 'university',
      sections: [
        CommunityCatalogSection(
          key: 'clubs',
          title: 'Clubs',
          emoji: '🤖',
          items: [
            for (var index = 0; index < 12; index++)
              CommunityCatalogEntry(
                id: 'entry-$index',
                slug: 'robotics-$index',
                title: 'Robotics club $index',
                description: 'Build robots together',
                url: 'https://t.me/robotics$index',
                platform: 'telegram',
              ),
          ],
        ),
      ],
    );
    await tester.pumpApp(
      subject(
        CommunityCatalogState(status: .success, catalog: longCatalog),
      ),
    );

    expect(find.byType(CustomScrollView), findsOneWidget);
    final search = find.byType(NinjaInput);
    final initialTop = tester.getTopLeft(search).dy;

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -420));
    await tester.pumpAndSettle();
    final pinnedTop = tester.getTopLeft(search).dy;

    expect(pinnedTop, lessThan(initialTop));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -180));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(search).dy, closeTo(pinnedTop, 0.1));
  });

  testWidgets('suggestion card is the single pastel card of the catalog', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(
        const CommunityCatalogState(
          status: .success,
          catalog: CommunityCatalog(
            organizationId: 'university',
            suggestionUrl: 'https://t.me/suggest',
            sections: [
              CommunityCatalogSection(
                key: 'clubs',
                title: 'Clubs',
                emoji: '🤖',
                items: [entry],
              ),
            ],
          ),
        ),
      ),
    );

    final colors = NinjaColors.light();
    final pastel = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .where((decoration) => decoration.color == colors.accentSoft)
        .toList();
    expect(pastel, hasLength(1));
    expect(
      pastel.single.borderRadius,
      BorderRadius.circular(NinjaRadius.card),
    );
    expect(find.byType(NinjaCommunitySuggestionCard), findsOneWidget);
  });

  testWidgets('failed URL launch shows feedback', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: NinjaCommunityCard(entry: entry, onLaunch: (_) async => false),
      ),
    );

    await tester.tap(find.byType(NinjaCommunityCard));
    await tester.pump();

    expect(find.text('Ошибка'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });

  test('platform detection uses the parsed host', () {
    expect(
      communityPlatformFor(Uri.parse('https://t.me/example')),
      CommunityPlatform.telegram,
    );
    expect(
      communityPlatformFor(Uri.parse('https://evil.example/?next=t.me')),
      CommunityPlatform.web,
    );
  });

  test('unsafe community schemes are rejected', () {
    expect(safeCommunityUri('http://t.me/example'), isNull);
    expect(safeCommunityUri('javascript:alert(1)'), isNull);
    expect(safeCommunityUri('https://t.me/example'), isNotNull);
  });
}
