import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/services/cubit/cubit.dart';
import 'package:rtu_mirea_app/services/data/services_directory.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:rtu_mirea_app/services/view/services_view.dart';
import 'package:rtu_mirea_app/services/view/widgets/service_row.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_feature_card.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_grid_skeleton.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

import '../../helpers/pump_app.dart';

class _Catalog extends MockCubit<ServiceCatalogState>
    implements ServiceCatalogCubit {}

class _Favorites extends MockCubit<FavoriteServicesState>
    implements FavoriteServicesCubit {}

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Pass extends MockCubit<NfcPassState> implements NfcPassCubit {}

class _Hce extends MockCubit<NfcHceState> implements NfcHceCubit {}

class _CatalogRepository extends Mock implements ServiceCatalogRepository {}

void main() {
  late _Catalog catalog;
  late _Favorites favorites;
  late _Schedule schedule;
  const config = UniversityConfig(
    organizationId: 'test',
    appName: 'Test',
    universityName: 'Test',
    universityShortName: 'T',
    websiteUrl: 'https://example.test',
    supportEmail: 'support@example.test',
    deepLinkScheme: 'test',
    webAppHost: 'app.example.test',
    webAppPathPrefix: '/app',
    enabledCapabilities: {},
  );

  setUpAll(
    () => registerFallbackValue(
      ServiceModel(
        title: 'Test',
        icon: AppLineIcon.book,
        color: AppColors.light.ink,
        isExternal: false,
        routePath: '/services/deadlines',
      ),
    ),
  );
  setUp(() {
    catalog = _Catalog();
    favorites = _Favorites();
    schedule = _Schedule();
    when(() => catalog.state).thenReturn(const ServiceCatalogState());
    when(
      () => catalog.load(locale: any(named: 'locale')),
    ).thenAnswer((_) async {});
    when(() => favorites.state).thenReturn(FavoriteServicesState());
    when(() => favorites.toggle(any())).thenAnswer((_) async {});
    when(() => schedule.state).thenReturn(const ScheduleState());
  });

  Widget subject({
    UniversityConfig deployment = config,
    ServiceCatalogCubit? currentCatalog,
  }) => RepositoryProvider.value(
    value: deployment,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ServiceCatalogCubit>.value(
          value: currentCatalog ?? catalog,
        ),
        BlocProvider<FavoriteServicesCubit>.value(value: favorites),
        BlocProvider<ScheduleBloc>.value(value: schedule),
      ],
      child: const ServicesView(),
    ),
  );

  testWidgets(
    'iOS never initializes the featured pass card',
    (tester) async {
      await tester.pumpApp(
        subject(deployment: UniversityConfig.current),
        size: const Size(400, 2000),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('services-nfc-card')), findsNothing);
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets(
    'renders named sections and the actual catalog without disabled NFC',
    (tester) async {
      await tester.pumpApp(subject(), size: const Size(400, 1000));
      expect(find.text('Сервисы'), findsOneWidget);
      expect(find.byKey(const ValueKey('services-search')), findsOneWidget);
      expect(find.byKey(const ValueKey('services-nfc-card')), findsNothing);
      expect(find.byType(ServiceRow), findsWidgets);
      verify(() => catalog.load(locale: 'ru')).called(1);
    },
  );

  testWidgets('configure toggles favorites without navigating', (tester) async {
    await tester.pumpApp(subject(), size: const Size(400, 1000));
    final height = tester.getSize(find.byType(ServiceRow).first).height;
    expect(height, greaterThanOrEqualTo(AppControlSize.touchTarget));
    await tester.tap(find.byKey(const ValueKey('services-edit-toggle')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('services-edit-banner')), findsOneWidget);
    final row = tester.widget<ServiceRow>(find.byType(ServiceRow).first);
    expect(row.editMode, isTrue);
    expect(tester.getSize(find.byType(ServiceRow).first).height, height);
    row.onToggleFavorite!();
    verify(() => favorites.toggle(row.entry.model)).called(1);
    await tester.tap(find.byKey(const ValueKey('services-edit-toggle')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('services-edit-banner')), findsNothing);
  });

  for (final width in [320.0, 390.0]) {
    testWidgets('service cards remain compact and editable at $width', (
      tester,
    ) async {
      await tester.pumpApp(subject(), size: Size(width, 1200));
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(ServicesFeatureCard)).height,
        lessThanOrEqualTo(128),
      );
      for (final row in find.byType(ServiceRow).evaluate()) {
        expect(
          tester.getSize(find.byWidget(row.widget)).height,
          lessThanOrEqualTo(130),
        );
      }
      await tester.tap(find.byKey(const ValueKey('services-edit-toggle')));
      await tester.pumpAndSettle();
      final row = tester.widget<ServiceRow>(find.byType(ServiceRow).first);
      final star = find.byKey(ValueKey('service-star-${row.entry.id}'));
      final target = tester.getSize(star);
      expect(target.width, greaterThanOrEqualTo(44));
      expect(target.height, greaterThanOrEqualTo(44));
      await tester.tap(star);
      await tester.pump();
      verify(() => favorites.toggle(row.entry.model)).called(1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('configure hit target preserves the header and search spacing', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    final header = tester.getRect(find.byType(AppScreenHeader));
    final title = tester.getRect(find.text('Сервисы'));
    final search = tester.getRect(
      find.byKey(const ValueKey('services-search')),
    );
    final action = tester.getRect(
      find.byKey(const ValueKey('services-edit-toggle')),
    );
    expect(
      title.topLeft,
      const Offset(AppSpacing.screen, AppSpacing.screenTop),
    );
    expect(header.bottom, title.bottom);
    expect(search.top - header.bottom, AppSpacing.gap);
    expect(action.height, AppControlSize.touchTarget);
    expect(action.width, greaterThanOrEqualTo(AppControlSize.touchTarget));
    await tester.tapAt(action.topCenter + const Offset(0, 1));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('services-edit-banner')), findsOneWidget);
  });

  testWidgets('configure remains available at narrow 200 percent text', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(),
      size: const Size(320, 844),
      textScaler: const TextScaler.linear(2),
    );
    final action = find.byKey(const ValueKey('services-edit-toggle'));
    expect(
      tester.getSize(action).height,
      greaterThanOrEqualTo(AppControlSize.touchTarget),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(action);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('services-edit-banner')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cold catalog loading keeps built-in services visible', (
    tester,
  ) async {
    when(
      () => catalog.state,
    ).thenReturn(const ServiceCatalogState(isLoading: true));
    await tester.pumpApp(subject(), size: const Size(400, 1000));
    expect(find.byType(ServiceRow), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'cold catalog failure offers a real retry and preserves favorites',
    (
      tester,
    ) async {
      final repository = _CatalogRepository();
      final realCatalog = ServiceCatalogCubit(repository);
      addTearDown(realCatalog.close);
      var attempts = 0;
      when(() => repository.getCatalog(locale: 'ru')).thenAnswer((_) async {
        if (++attempts == 1) throw Exception('Offline');
        return const ServiceCatalog(
          organizationId: 'test',
          sections: [
            ServiceCatalogSection(
              key: 'portal',
              title: 'Университет',
              sortOrder: 0,
              items: [
                ServiceCatalogEntry(
                  id: 'portal',
                  slug: 'portal',
                  title: 'Университетский портал',
                  description: 'Учебные сервисы',
                  url: 'https://example.test/portal',
                  iconKey: 'globe',
                  colorKey: 'accent',
                  sortOrder: 0,
                ),
              ],
            ),
          ],
        );
      });
      when(() => favorites.state).thenReturn(
        FavoriteServicesState(ids: {'/services/events'}, loaded: true),
      );
      await tester.pumpApp(subject(currentCatalog: realCatalog));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('services-catalog-error')),
        findsOneWidget,
      );
      expect(find.text('Закреплённые'), findsOneWidget);
      expect(find.byType(ServiceRow), findsWidgets);
      await tester.tap(find.text('Повторить'));
      await tester.pumpAndSettle();
      verify(() => repository.getCatalog(locale: 'ru')).called(2);
      expect(
        find.byKey(const ValueKey('services-catalog-error')),
        findsNothing,
      );
      expect(find.text('Закреплённые'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Университетский портал'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Университетский портал'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('catalog loading grid announces loading at narrow large text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    when(
      () => catalog.state,
    ).thenReturn(const ServiceCatalogState(isLoading: true));
    await tester.pumpApp(
      subject(),
      size: const Size(320, 844),
      textScaler: const TextScaler.linear(2),
    );
    final skeleton = find.byType(ServicesGridSkeleton);
    await tester.scrollUntilVisible(
      skeleton,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(skeleton, findsOneWidget);
    await tester.pump();
    final label = find.bySemanticsLabel('Загрузка');
    expect(label, findsOneWidget);
    expect(tester.getSemantics(label).flagsCollection.isLiveRegion, isTrue);
    expect(find.byType(AppSkeletonRow), findsNothing);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets(
    'favorite NFC is shown once and remains editable in its category',
    (tester) async {
      const nfcConfig = UniversityConfig(
        organizationId: 'test',
        appName: 'Test',
        universityName: 'Test',
        universityShortName: 'T',
        websiteUrl: 'https://example.test',
        supportEmail: 'support@example.test',
        deepLinkScheme: 'test',
        webAppHost: 'app.example.test',
        webAppPathPrefix: '/app',
        enabledCapabilities: {UniversityCapability.nfcPass},
      );
      final pass = _Pass();
      final hce = _Hce();
      when(() => pass.state).thenReturn(const NfcPassState());
      when(() => hce.state).thenReturn(const NfcHceState(loaded: true));
      when(() => favorites.state).thenReturn(
        FavoriteServicesState(ids: {'/services/nfc'}, loaded: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<NfcPassCubit>.value(value: pass),
            BlocProvider<NfcHceCubit>.value(value: hce),
          ],
          child: subject(deployment: nfcConfig),
        ),
        size: const Size(390, 844),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('services-nfc-card')), findsOneWidget);
      expect(
        tester
            .widgetList<ServiceRow>(find.byType(ServiceRow))
            .where(
              (row) => row.entry.model.routePath == '/services/nfc',
            ),
        isEmpty,
      );
      final campus = find.byKey(const ValueKey('services-category-campus'));
      await tester.scrollUntilVisible(
        campus,
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(campus);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('services-nfc-card')), findsNothing);
      final nfc = tester
          .widgetList<ServiceRow>(find.byType(ServiceRow))
          .singleWhere(
            (row) => row.entry.model.routePath == '/services/nfc',
          );
      expect(nfc.favorite, isTrue);
      final edit = find.byKey(const ValueKey('services-edit-toggle'));
      await tester.scrollUntilVisible(
        edit,
        -400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(edit);
      await tester.pumpAndSettle();
      final star = find.byKey(const ValueKey('service-star-/services/nfc'));
      await tester.ensureVisible(star);
      await tester.tap(star);
      verify(() => favorites.toggle(nfc.entry.model)).called(1);
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

  testWidgets('catalog search leaves the viewport when browsing services', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 600));
    final search = find.byKey(const ValueKey('services-search'));
    expect(search.hitTestable(), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
    await tester.pumpAndSettle();
    expect(search.hitTestable(), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('large catalog builds visible services at text scale $scale', (
      tester,
    ) async {
      when(() => catalog.state).thenReturn(
        ServiceCatalogState(
          catalog: ServiceCatalog(
            organizationId: 'test',
            sections: [
              ServiceCatalogSection(
                key: 'portal',
                title: 'Университет',
                sortOrder: 0,
                items: [
                  for (var index = 0; index < 100; index++)
                    ServiceCatalogEntry(
                      id: 'portal-$index',
                      slug: 'portal-$index',
                      title: 'Университетский портал $index',
                      description: 'Учебные сервисы',
                      url: 'https://example.test/portal/$index',
                      iconKey: 'globe',
                      colorKey: 'accent',
                      sortOrder: index,
                    ),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pumpApp(
        subject(),
        size: const Size(320, 844),
        textScaler: TextScaler.linear(scale),
      );
      expect(find.byType(ServiceRow).evaluate().length, lessThanOrEqualTo(20));
      expect(find.text('Университетский портал 99'), findsNothing);
      final category = find.byKey(const ValueKey('services-category-portal'));
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('services-categories')),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(category);
      await tester.tap(category);
      await tester.pumpAndSettle();
      tester
          .widget<CustomScrollView>(find.byType(CustomScrollView))
          .controller!
          .jumpTo(0);
      await tester.pump();
      final first = find.text('Университетский портал 0');
      await tester.scrollUntilVisible(
        first,
        400,
        scrollable: find.byType(Scrollable).first,
      );
      expect(first, findsOneWidget);
      expect(find.byType(ServiceRow).evaluate().length, lessThanOrEqualTo(20));
      expect(find.text('Университетский портал 99'), findsNothing);
      await tester.scrollUntilVisible(
        find.text('Университетский портал 99'),
        600,
        maxScrolls: 100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Университетский портал 99'), findsOneWidget);
      expect(first, findsNothing);
      expect(find.byType(ServiceRow).evaluate().length, lessThanOrEqualTo(20));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('category viewport accepts edge swipes at 320px and 200% text', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(),
      size: const Size(320, 900),
      textScaler: const TextScaler.linear(2),
    );
    final rail = find.byKey(const ValueKey('services-categories'));
    await tester.scrollUntilVisible(
      rail,
      240,
      scrollable: find
          .descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    final viewport = tester.getRect(rail);
    expect(viewport.left, 0);
    expect(viewport.right, 320);
    expect(
      tester.getRect(find.byKey(const ValueKey('services-category-all'))).left,
      AppSpacing.screen,
    );
    final scroll = tester.state<ScrollableState>(
      find.descendant(of: rail, matching: find.byType(Scrollable)),
    );
    final before = scroll.position.pixels;
    await tester.dragFrom(
      Offset(318, viewport.center.dy),
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();
    expect(scroll.position.pixels, greaterThan(before));
    final offset = scroll.position.pixels;
    await tester.dragFrom(Offset(2, viewport.center.dy), const Offset(220, 0));
    await tester.pumpAndSettle();
    expect(scroll.position.pixels, lessThan(offset));
    final study = find.byKey(const ValueKey('services-category-study'));
    await tester.ensureVisible(study);
    await tester.tap(study);
    await tester.pumpAndSettle();
    expect(tester.widget<AppChip>(study).selected, isTrue);
    expect(
      find.byKey(const ValueKey('services-section-study')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'category chips filter the directory without duplicate shortcuts',
    (
      tester,
    ) async {
      await tester.pumpApp(subject(), size: const Size(390, 844));
      final category = find.byKey(const ValueKey('services-category-study'));
      await tester.ensureVisible(category);
      await tester.tap(category);
      await tester.pumpAndSettle();
      expect(find.byType(ServicesFeatureCard), findsNothing);
      expect(
        find.byKey(const ValueKey('services-section-study')),
        findsOneWidget,
      );
      final context = tester.element(find.byType(ServicesView));
      final section = ServicesDirectory.sections(
        context,
        config: config,
      ).singleWhere((section) => section.key == ServicesDirectory.sectionStudy);
      final visible = tester.widgetList<ServiceRow>(find.byType(ServiceRow));
      expect(
        visible.map((row) => row.entry.id).toSet(),
        section.entries.map((entry) => entry.id).toSet(),
      );
      final all = find.byKey(const ValueKey('services-category-all'));
      await tester.ensureVisible(all);
      await tester.tap(all);
      await tester.pumpAndSettle();
      expect(tester.widget<AppChip>(all).selected, isTrue);
      expect(find.byType(ServicesFeatureCard), findsOneWidget);
      expect(
        find.byKey(const ValueKey('services-section-all')),
        findsOneWidget,
      );
      final restored = tester
          .widgetList<ServiceRow>(find.byType(ServiceRow))
          .toList();
      expect(
        restored.map((row) => row.entry.id).toSet(),
        hasLength(restored.length),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('pinned services replace quick suggestions and stay editable', (
    tester,
  ) async {
    when(() => favorites.state).thenReturn(
      FavoriteServicesState(ids: {'/services/events'}, loaded: true),
    );
    await tester.pumpApp(subject(), size: const Size(390, 844));
    expect(find.text('Закреплённые'), findsOneWidget);
    final row = tester.widget<ServiceRow>(find.byType(ServiceRow).first);
    expect(row.entry.model.routePath, '/services/events');
    expect(row.favorite, isTrue);
    await tester.tap(find.byKey(const ValueKey('services-edit-toggle')));
    await tester.pumpAndSettle();
    final control = find.byKey(const ValueKey('service-star-/services/events'));
    await tester.ensureVisible(control);
    await tester.tap(control);
    verify(() => favorites.toggle(row.entry.model)).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pinned services keep the saved selection order', (tester) async {
    const ids = ['/services/polls', '/services/events'];
    when(() => favorites.state).thenReturn(
      FavoriteServicesState(ids: ids.toSet(), loaded: true),
    );
    await tester.pumpApp(subject(), size: const Size(390, 844));

    final rows = tester.widgetList<ServiceRow>(find.byType(ServiceRow));
    expect(rows.take(2).map((row) => row.entry.id), ids);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pins mini apps and first-party services before the directory', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    final context = tester.element(find.byType(ServicesView));
    final sections = ServicesDirectory.sections(context, config: config);
    expect(sections.first.key, ServicesDirectory.sectionFirstParty);
    final pinnedRoutes = sections.first.entries
        .map((entry) => entry.model.routePath)
        .toList();
    expect(
      pinnedRoutes.take(4),
      [
        '/services/apps',
        '/services/deadlines',
        '/services/events',
        '/services/team-finder',
      ],
    );
    expect(
      pinnedRoutes,
      containsAll([
        '/services/knowledge-bank',
        '/services/marketplace',
        '/services/wallet',
        '/services/friends',
      ]),
    );
    expect(
      pinnedRoutes,
      isNot(
        anyElement(
          isIn([
            '/services/free-rooms',
            '/services/nfc',
            '/services/people',
            '/services/polls',
            '/services/communities',
            '/feed/news',
            '/services/collab-notes',
            '/schedule/session',
            '/services/mentorship',
          ]),
        ),
      ),
    );
    expect(
      sections
          .skip(1)
          .expand((section) => section.entries)
          .map((entry) => entry.model.routePath),
      containsAll(['/services/mentorship', '/services/polls']),
    );
    final ids = sections.expand((section) => section.entries).map((e) => e.id);
    expect(ids.toSet().length, ids.length);
    expect(
      tester
          .widget<ServicesFeatureCard>(find.byType(ServicesFeatureCard))
          .entry
          .model
          .routePath,
      '/services/apps',
    );
    final list = tester.widget<CustomScrollView>(find.byType(CustomScrollView));
    expect(
      (list.slivers.last as SliverPadding).padding
          .resolve(TextDirection.ltr)
          .bottom,
      AppBottomBar.extentOf(context) + AppSpacing.screen,
    );
  });

  testWidgets('reselect jumps to the top when motion is reduced', (
    tester,
  ) async {
    await tester.pumpApp(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: subject(),
      ),
      size: const Size(390, 600),
    );
    final list = tester.widget<CustomScrollView>(find.byType(CustomScrollView));
    list.controller!.jumpTo(100);
    await tester.pump();
    expect(list.controller!.offset, greaterThan(0));
    TabReselectNotifier.instance.reselect(3);
    expect(list.controller!.offset, 0);
    expect(tester.takeException(), isNull);
  });
}
