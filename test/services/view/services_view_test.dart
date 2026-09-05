import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/services/cubit/cubit.dart';
import 'package:rtu_mirea_app/services/data/services_directory.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:rtu_mirea_app/services/view/services_view.dart';
import 'package:rtu_mirea_app/services/view/widgets/service_row.dart';

import '../../helpers/pump_app.dart';

class _Catalog extends MockCubit<ServiceCatalogState>
    implements ServiceCatalogCubit {}

class _Favorites extends MockCubit<FavoriteServicesState>
    implements FavoriteServicesCubit {}

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

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

  Widget subject() => RepositoryProvider.value(
    value: config,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ServiceCatalogCubit>.value(value: catalog),
        BlocProvider<FavoriteServicesCubit>.value(value: favorites),
        BlocProvider<ScheduleBloc>.value(value: schedule),
      ],
      child: const ServicesView(),
    ),
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
    expect(tester.getSize(find.byType(ServiceRow).first).height, 56);
    await tester.tap(find.byKey(const ValueKey('services-edit-toggle')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('services-edit-banner')), findsOneWidget);
    final row = tester.widget<ServiceRow>(find.byType(ServiceRow).first);
    expect(row.editMode, isTrue);
    expect(tester.getSize(find.byType(ServiceRow).first).height, 56);
    row.onToggleFavorite!();
    verify(() => favorites.toggle(row.entry.model)).called(1);
    await tester.tap(find.byKey(const ValueKey('services-edit-toggle')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('services-edit-banner')), findsNothing);
  });

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
    expect(search.top - header.bottom, AppSpacing.fieldGap);
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
          .widget<ServiceRow>(find.byType(ServiceRow).first)
          .entry
          .model
          .routePath,
      '/services/apps',
    );
    final list = tester.widget<CustomScrollView>(find.byType(CustomScrollView));
    expect(
      (list.slivers.single as SliverPadding).padding
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
