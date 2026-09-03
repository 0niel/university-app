import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_stats_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_moderation_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_skeleton.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_stats_page.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_moderation_page.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_page.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/widgets.dart';

class MockMiniAppsCatalogCubit extends MockCubit<MiniAppsCatalogState>
    implements MiniAppsCatalogCubit {}

class MockMiniAppsModerationCubit extends MockCubit<MiniAppsModerationState>
    implements MiniAppsModerationCubit {}

class MockMiniAppStatsCubit extends MockCubit<MiniAppStatsState>
    implements MiniAppStatsCubit {}

Widget _wrap(
  Widget child, {
  double textScale = 1,
  bool reduceMotion = false,
}) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        disableAnimations: reduceMotion,
        accessibleNavigation: reduceMotion,
      ),
      child: child!,
    ),
    home: child,
  );
}

void main() {
  setUpAll(() => registerFallbackValue(MiniAppSort.popular));

  testWidgets('runner cold load announces one localized live region', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_wrap(const MiniAppRunnerSkeleton()));

    final finder = find.bySemanticsLabel('Загрузка');
    expect(finder, findsOneWidget);
    expect(tester.getSemantics(finder).flagsCollection.isLiveRegion, isTrue);
    semantics.dispose();
  });

  group('MiniAppsView loading skeleton', () {
    late MiniAppsCatalogCubit cubit;

    setUp(() {
      cubit = MockMiniAppsCatalogCubit();
      when(() => cubit.state).thenReturn(
        const MiniAppsCatalogState(status: MiniAppsCatalogStatus.loading),
      );
    });

    testWidgets('shows skeleton and no spinner on cold load', (tester) async {
      await tester.pumpWidget(
        _wrap(
          BlocProvider<MiniAppsCatalogCubit>.value(
            value: cubit,
            child: const MiniAppsView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(MiniAppCardSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('fits a compact screen with large text', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrap(
          BlocProvider<MiniAppsCatalogCubit>.value(
            value: cubit,
            child: const MiniAppsView(),
          ),
          textScale: 2,
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('MiniAppsView sorting', () {
    late MiniAppsCatalogCubit cubit;

    setUp(() {
      cubit = MockMiniAppsCatalogCubit();
      when(() => cubit.state).thenReturn(
        const MiniAppsCatalogState(status: MiniAppsCatalogStatus.populated),
      );
      when(() => cubit.sortChanged(any())).thenAnswer((_) async {});
    });

    testWidgets('uses one compact sort action instead of catalog tabs', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          BlocProvider<MiniAppsCatalogCubit>.value(
            value: cubit,
            child: const MiniAppsView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaSegmented<MiniAppSort>), findsNothing);
      final sortAction = find.byKey(const ValueKey('mini-apps-sort-button'));
      expect(sortAction, findsOneWidget);
      expect(tester.getRect(sortAction).height, greaterThanOrEqualTo(44));

      final pill = tester.widget<Container>(
        find.descendant(of: sortAction, matching: find.byType(Container)).first,
      );
      expect(
        (pill.decoration! as BoxDecoration).borderRadius,
        BorderRadius.circular(AppRadius.full),
      );

      await tester.tap(sortAction);
      await tester.pumpAndSettle();
      expect(find.text('Сортировка'), findsOneWidget);

      await tester.tap(find.text('Топ'));
      await tester.pumpAndSettle();
      verify(() => cubit.sortChanged(MiniAppSort.top)).called(1);
    });

    testWidgets('renders recent apps with the shared service tile', (
      tester,
    ) async {
      const app = MiniApp(
        id: 'recent',
        slug: 'recent',
        name: 'Недавний апп',
      );
      when(() => cubit.state).thenReturn(
        const MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          apps: [app],
          recents: [app],
        ),
      );

      await tester.pumpWidget(
        _wrap(
          BlocProvider<MiniAppsCatalogCubit>.value(
            value: cubit,
            child: const MiniAppsView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AppServiceTile), findsOneWidget);
      expect(find.text('Недавний апп'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('MiniAppsView empty states', () {
    late MiniAppsCatalogCubit cubit;

    setUp(() {
      cubit = MockMiniAppsCatalogCubit();
      when(() => cubit.queryChanged(any())).thenAnswer((_) async {});
      when(() => cubit.categoryChanged(any())).thenAnswer((_) async {});
    });

    testWidgets('an empty catalog offers a real create action', (tester) async {
      when(() => cubit.state).thenReturn(
        const MiniAppsCatalogState(status: MiniAppsCatalogStatus.populated),
      );

      await tester.pumpWidget(
        _wrap(
          BlocProvider<MiniAppsCatalogCubit>.value(
            value: cubit,
            child: const MiniAppsView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.text('Мини-аппов пока нет'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(NinjaEmptyState),
          matching: find.text('Создать'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('a fruitless filter offers a reset action', (tester) async {
      const mine = MiniApp(id: 'mine', slug: 'mine', name: 'Мой апп');
      when(() => cubit.state).thenReturn(
        const MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          myApps: [mine],
        ),
      );

      await tester.pumpWidget(
        _wrap(
          BlocProvider<MiniAppsCatalogCubit>.value(
            value: cubit,
            child: const MiniAppsView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.text('Ничего не нашлось'), findsOneWidget);
      await tester.ensureVisible(find.text('Сбросить фильтр'));
      await tester.pump();
      await tester.tap(find.text('Сбросить фильтр'));
      await tester.pump();

      verify(() => cubit.categoryChanged(null)).called(1);
      verify(() => cubit.queryChanged('')).called(1);
    });
  });

  group('MiniAppsModerationView loading skeleton', () {
    late MiniAppsModerationCubit cubit;

    setUp(() {
      cubit = MockMiniAppsModerationCubit();
      when(() => cubit.state).thenReturn(
        const MiniAppsModerationState(
          status: MiniAppsModerationStatus.loading,
        ),
      );
    });

    testWidgets('shows skeleton and no spinner on cold load', (tester) async {
      await tester.pumpWidget(
        _wrap(
          BlocProvider<MiniAppsModerationCubit>.value(
            value: cubit,
            child: const MiniAppsModerationView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(MiniAppCardSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('an empty queue offers a refresh action', (tester) async {
      when(() => cubit.state).thenReturn(
        const MiniAppsModerationState(
          status: MiniAppsModerationStatus.populated,
        ),
      );
      when(() => cubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(
        _wrap(
          BlocProvider<MiniAppsModerationCubit>.value(
            value: cubit,
            child: const MiniAppsModerationView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.text('Очередь пуста'), findsOneWidget);
      await tester.tap(find.text('Обновить данные'));
      verify(() => cubit.load()).called(1);
    });
  });

  group('MiniAppStatsView loading skeleton', () {
    late MiniAppStatsCubit cubit;

    const app = MiniApp(id: 'app-1', slug: 'demo', name: 'Demo');

    setUp(() {
      cubit = MockMiniAppStatsCubit();
      when(() => cubit.state).thenReturn(
        const MiniAppStatsState(status: MiniAppStatsStatus.loading),
      );
    });

    testWidgets('shows skeleton and no spinner on cold load', (tester) async {
      await tester.pumpWidget(
        _wrap(
          BlocProvider<MiniAppStatsCubit>.value(
            value: cubit,
            child: const MiniAppStatsView(app: app),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
