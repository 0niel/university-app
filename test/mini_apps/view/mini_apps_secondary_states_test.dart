import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_stats_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_submit_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_moderation_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_inner_screen.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_body.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_stats_page.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_submit_page.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_moderation_page.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_page.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scaffold.dart';

class _StatsCubit extends MockCubit<MiniAppStatsState>
    implements MiniAppStatsCubit {}

class _ModerationCubit extends MockCubit<MiniAppsModerationState>
    implements MiniAppsModerationCubit {}

class _CatalogCubit extends MockCubit<MiniAppsCatalogState>
    implements MiniAppsCatalogCubit {}

class _SubmitCubit extends MockCubit<MiniAppSubmitState>
    implements MiniAppSubmitCubit {}

class _RunnerCubit extends MockCubit<MiniAppRunnerState>
    implements MiniAppRunnerCubit {}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  bool dark = false,
  double scale = 2,
}) async {
  tester.view
    ..physicalSize = const Size(320, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(scale),
          disableAnimations: true,
          accessibleNavigation: true,
        ),
        child: child!,
      ),
      home: child,
    ),
  );
  await tester.pump();
}

void main() {
  const app = MiniApp(
    id: 'demo',
    slug: 'demo',
    name: 'Расширенная статистика учебных материалов',
  );

  for (final dark in [false, true]) {
    for (final status in [
      MiniAppStatsStatus.loading,
      MiniAppStatsStatus.populated,
      MiniAppStatsStatus.failure,
    ]) {
      testWidgets('stats $status is accessible at 200% dark=$dark', (
        tester,
      ) async {
        final cubit = _StatsCubit();
        when(() => cubit.state).thenReturn(MiniAppStatsState(status: status));
        when(cubit.load).thenAnswer((_) async {});
        await _pump(
          tester,
          BlocProvider<MiniAppStatsCubit>.value(
            value: cubit,
            child: const MiniAppStatsView(app: app),
          ),
          dark: dark,
        );
        expect(find.byType(AppInnerHeader), findsOneWidget);
        expect(tester.takeException(), isNull);
        if (status != MiniAppStatsStatus.loading) {
          final label = status == MiniAppStatsStatus.failure
              ? 'Повторить'
              : 'Обновить данные';
          await tester.ensureVisible(find.text(label));
          await tester.tap(find.text(label));
          verify(cubit.load).called(1);
        }
      });
    }

    for (final status in [
      MiniAppsModerationStatus.loading,
      MiniAppsModerationStatus.populated,
      MiniAppsModerationStatus.failure,
    ]) {
      testWidgets('moderation $status is accessible at 200% dark=$dark', (
        tester,
      ) async {
        final cubit = _ModerationCubit();
        when(() => cubit.state).thenReturn(
          MiniAppsModerationState(status: status),
        );
        when(cubit.load).thenAnswer((_) async {});
        await _pump(
          tester,
          BlocProvider<MiniAppsModerationCubit>.value(
            value: cubit,
            child: const MiniAppsModerationView(),
          ),
          dark: dark,
        );
        expect(find.byType(AppInnerHeader), findsOneWidget);
        expect(tester.takeException(), isNull);
        if (status != MiniAppsModerationStatus.loading) {
          final label = status == MiniAppsModerationStatus.failure
              ? 'Повторить'
              : 'Обновить данные';
          await tester.ensureVisible(find.text(label));
          await tester.tap(find.text(label));
          verify(cubit.load).called(1);
        }
      });
    }

    testWidgets('populated statistics wrap the legend at 200% dark=$dark', (
      tester,
    ) async {
      final cubit = _StatsCubit();
      when(() => cubit.state).thenReturn(
        MiniAppStatsState(
          status: .populated,
          stats: [
            MiniAppDailyStat(day: DateTime(2026, 9, 2), launches: 12000),
          ],
        ),
      );
      await _pump(
        tester,
        BlocProvider<MiniAppStatsCubit>.value(
          value: cubit,
          child: const MiniAppStatsView(app: app),
        ),
        dark: dark,
      );
      await tester.drag(find.byType(ListView), const Offset(0, -900));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('populated catalog fits real large counts at 200% dark=$dark', (
      tester,
    ) async {
      final cubit = _CatalogCubit();
      when(() => cubit.state).thenReturn(
        MiniAppsCatalogState(
          status: .populated,
          apps: [
            app.copyWith(launchCount: 1234567, ratingAvg: 4.5, ratingCount: 15),
          ],
        ),
      );
      await _pump(
        tester,
        BlocProvider<MiniAppsCatalogCubit>.value(
          value: cubit,
          child: const MiniAppsView(),
        ),
        dark: dark,
      );
      expect(find.byType(AppInnerHeader), findsOneWidget);
      expect(find.text(app.name), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    for (final status in [
      MiniAppSubmitStatus.idle,
      MiniAppSubmitStatus.submitting,
    ]) {
      testWidgets('submission $status preserves fields at 200% dark=$dark', (
        tester,
      ) async {
        final cubit = _SubmitCubit();
        when(() => cubit.state).thenReturn(MiniAppSubmitState(status: status));
        await _pump(
          tester,
          BlocProvider<MiniAppSubmitCubit>.value(
            value: cubit,
            child: const MiniAppSubmitView(),
          ),
          dark: dark,
        );
        expect(find.byType(AppInnerHeader), findsOneWidget);
        expect(find.byType(AppInputField), findsWidgets);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('submission opens documentation in the external browser', (
    tester,
  ) async {
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    MethodCall? launchCall;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      launchCall = call;
      return true;
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    final cubit = _SubmitCubit();
    when(() => cubit.state).thenReturn(const MiniAppSubmitState());
    await _pump(
      tester,
      BlocProvider<MiniAppSubmitCubit>.value(
        value: cubit,
        child: const MiniAppSubmitView(),
      ),
      scale: 1,
    );
    await tester.tap(find.text('docs.mirea.ninja'));
    await tester.pump();
    expect(launchCall?.method, 'launch');
    expect(
      launchCall?.arguments,
      containsPair('url', 'https://docs.mirea.ninja/'),
    );
    expect(launchCall?.arguments, containsPair('useWebView', false));
    expect(tester.takeException(), isNull);
  });

  testWidgets('catalog filter without owned apps offers reset, not create', (
    tester,
  ) async {
    final cubit = _CatalogCubit();
    when(() => cubit.state).thenReturn(
      const MiniAppsCatalogState(status: .populated, query: 'physics'),
    );
    when(() => cubit.queryChanged('')).thenAnswer((_) async {});
    when(() => cubit.categoryChanged(null)).thenAnswer((_) async {});
    await _pump(
      tester,
      BlocProvider<MiniAppsCatalogCubit>.value(
        value: cubit,
        child: const MiniAppsView(),
      ),
    );
    expect(find.byType(AppInnerHeader), findsOneWidget);
    expect(find.text('Ничего не нашлось'), findsOneWidget);
    expect(find.text('Мини-аппов пока нет'), findsNothing);
    await tester.ensureVisible(find.text('Сбросить фильтр'));
    await tester.pump();
    expect(
      tester
          .getRect(find.text('Сбросить фильтр'))
          .overlaps(
            tester.getRect(find.byType(AppFab)),
          ),
      isFalse,
    );
    await tester.tap(find.text('Сбросить фильтр'));
    verify(() => cubit.queryChanged('')).called(1);
    verify(() => cubit.categoryChanged(null)).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('catalog failure retry remains clear of the create action', (
    tester,
  ) async {
    final cubit = _CatalogCubit();
    when(() => cubit.state).thenReturn(
      const MiniAppsCatalogState(status: .failure),
    );
    when(cubit.load).thenAnswer((_) async {});
    await _pump(
      tester,
      BlocProvider<MiniAppsCatalogCubit>.value(
        value: cubit,
        child: const MiniAppsView(),
      ),
    );
    final retry = find.text('Повторить');
    await tester.ensureVisible(retry);
    await tester.pump();
    expect(
      tester.getRect(retry).overlaps(tester.getRect(find.byType(AppFab))),
      isFalse,
    );
    await tester.tap(retry);
    verify(cubit.load).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('runner failure and inner-page retry remain reachable', (
    tester,
  ) async {
    final cubit = _RunnerCubit();
    when(cubit.load).thenAnswer((_) async {});
    await _pump(
      tester,
      BlocProvider<MiniAppRunnerCubit>.value(
        value: cubit,
        child: const MiniAppScaffold(
          title: 'Учебные материалы',
          body: MiniAppRunnerBody(
            state: MiniAppRunnerState(status: .failure),
          ),
        ),
      ),
    );
    await tester.ensureVisible(find.text('Повторить'));
    await tester.tap(find.text('Повторить'));
    verify(cubit.load).called(1);
    when(() => cubit.fetchPage('/missing')).thenAnswer((_) async => null);
    await _pump(
      tester,
      BlocProvider<MiniAppRunnerCubit>.value(
        value: cubit,
        child: const MiniAppInnerScreen(
          path: '/missing',
          title: 'Учебные материалы',
        ),
      ),
    );
    await tester.ensureVisible(find.text('Повторить'));
    await tester.tap(find.text('Повторить'));
    await tester.pump();
    verify(() => cubit.fetchPage('/missing')).called(2);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'mini app renderer paints under the host bar and retains the safe inset',
    (tester) async {
      const rendererKey = ValueKey('mini-renderer-surface');
      const controlsKey = ValueKey('mini-renderer-safe-controls');
      double? inheritedInset;
      await _pump(
        tester,
        AppBottomBarViewport(
          bottomInset: 96,
          child: MiniAppScaffold(
            title: 'Mini app',
            body: Builder(
              builder: (context) {
                inheritedInset = MediaQuery.paddingOf(context).bottom;
                return const Scaffold(
                  key: rendererKey,
                  backgroundColor: Colors.red,
                  body: SafeArea(child: SizedBox.expand(key: controlsKey)),
                );
              },
            ),
          ),
        ),
        scale: 1,
      );
      expect(tester.getRect(find.byKey(rendererKey)).bottom, 844);
      expect(tester.getRect(find.byKey(controlsKey)).bottom, 844 - 96);
      expect(inheritedInset, 96);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('inner header keeps 20px margin and 44px back target', (
    tester,
  ) async {
    var returned = false;
    await _pump(
      tester,
      MiniAppScaffold(
        title: 'Мини-аппы',
        onBack: () => returned = true,
        body: const SizedBox(),
      ),
      scale: 1,
    );
    final back = find.bySemanticsLabel('Назад');
    final backRect = tester.getRect(back);
    final titleRect = tester.getRect(find.text('Мини-аппы'));
    expect(backRect.left, AppSpacing.screen);
    expect(
      backRect.top < titleRect.top ? backRect.top : titleRect.top,
      AppSpacing.screenTop,
    );
    expect(backRect.center.dy, titleRect.center.dy);
    expect(tester.getSize(back), const Size(44, 44));
    final title = tester.widget<Text>(find.text('Мини-аппы'));
    expect(title.style?.fontFamily, AppText.displaySmall.fontFamily);
    expect(title.style?.fontSize, 28);
    await tester.tap(back);
    expect(returned, isTrue);
  });
}
