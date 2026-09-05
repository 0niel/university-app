import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/runtime/mini_app_accent.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_inner_screen.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_body.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_skeleton.dart';
import 'package:stac_bridge/stac_bridge.dart';

import '../../helpers/pump_app.dart';

class _RunnerCubit extends MockCubit<MiniAppRunnerState>
    implements MiniAppRunnerCubit {}

const _app = MiniApp(
  id: 'showcase',
  slug: 'showcase',
  name: 'Витрина возможностей',
  accentColor: '#8064FF',
);

const _screen = <String, dynamic>{
  'type': 'column',
  'children': [
    {'type': 'appText', 'data': 'Привет из витрины'},
    {'type': 'appButton', 'label': 'Кнопка'},
  ],
};

Future<void> _pumpBody(
  WidgetTester tester,
  MiniAppRunnerCubit cubit,
  MiniAppRunnerState state, {
  bool offline = false,
}) => tester.pumpApp(
  BlocProvider<MiniAppRunnerCubit>.value(
    value: cubit,
    child: Scaffold(
      body: MiniAppRunnerBody(state: state, offline: offline),
    ),
  ),
);

void main() {
  setUpAll(
    () => StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => null,
      ),
    ),
  );

  late _RunnerCubit cubit;

  setUp(() {
    cubit = _RunnerCubit();
    when(cubit.load).thenAnswer((_) async {});
  });

  testWidgets('loading shows the skeleton without spinners', (tester) async {
    await _pumpBody(tester, cubit, const MiniAppRunnerState(status: .loading));
    expect(find.byType(MiniAppRunnerSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('failure shows the kit error state with retry', (tester) async {
    await _pumpBody(tester, cubit, const MiniAppRunnerState(status: .failure));
    await tester.pumpAndSettle();
    expect(find.byType(AppErrorState), findsOneWidget);
    await tester.tap(find.text('Повторить'));
    verify(cubit.load).called(1);
  });

  testWidgets('not found shows the kit empty state', (tester) async {
    await _pumpBody(tester, cubit, const MiniAppRunnerState(status: .notFound));
    await tester.pumpAndSettle();
    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('Каталог'), findsOneWidget);
  });

  testWidgets('ready renders the screen through kit widgets with accent', (
    tester,
  ) async {
    await _pumpBody(
      tester,
      cubit,
      const MiniAppRunnerState(status: .ready, app: _app, screen: _screen),
    );
    await tester.pumpAndSettle();
    expect(find.text('Привет из витрины'), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget);
    expect(find.byType(AppBanner), findsNothing);
    final buttonContext = tester.element(find.byType(AppButton));
    expect(
      buttonContext.colors.accent,
      AppColors.accentColor(AppAccent.violet, isDark: false),
    );
    expect(miniAppAccentFor('#0E8A63'), AppAccent.green);
    expect(miniAppAccentFor('oops'), isNull);
  });

  testWidgets('offline cached screen shows the warn banner', (tester) async {
    await _pumpBody(
      tester,
      cubit,
      const MiniAppRunnerState(
        status: .ready,
        app: _app,
        screen: _screen,
        fromCache: true,
      ),
      offline: true,
    );
    await tester.pumpAndSettle();
    final banner = tester.widget<AppBanner>(find.byType(AppBanner));
    expect(banner.tone, AppBannerTone.warn);
    expect(find.text('Офлайн · показаны сохранённые данные'), findsOneWidget);
    await tester.tap(find.text('Повторить'));
    verify(cubit.load).called(1);
  });

  testWidgets('refresh preserves the input controller and focus', (
    tester,
  ) async {
    const formScreen = <String, dynamic>{
      'type': 'appInputField',
      'id': 'name',
      'label': 'Имя',
      'initialValue': 'Начальное имя',
    };
    const ready = MiniAppRunnerState(
      status: .ready,
      app: _app,
      screen: formScreen,
    );
    await _pumpBody(tester, cubit, ready);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Моё имя');
    final before = tester.widget<TextField>(find.byType(TextField));

    await _pumpBody(tester, cubit, ready.copyWith(refreshing: true));
    await tester.pump();
    final during = tester.widget<TextField>(find.byType(TextField));
    expect(find.byType(MiniAppRunnerSkeleton), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(during.controller, same(before.controller));
    expect(during.controller!.text, 'Моё имя');
    expect(during.focusNode!.hasFocus, isTrue);

    await _pumpBody(tester, cubit, ready.copyWith(refreshFailed: true));
    await tester.pump();
    final after = tester.widget<TextField>(find.byType(TextField));
    expect(after.controller, same(before.controller));
    expect(after.controller!.text, 'Моё имя');
    expect(after.focusNode!.hasFocus, isTrue);
    expect(find.byType(AppBanner), findsOneWidget);
  });

  testWidgets('inner refresh coalesces requests and preserves ready content', (
    tester,
  ) async {
    when(() => cubit.fetchPage('/profile')).thenAnswer((_) async => _screen);
    final controller = MiniAppInnerScreenController();
    await tester.pumpApp(
      BlocProvider<MiniAppRunnerCubit>.value(
        value: cubit,
        child: MiniAppInnerScreen(
          path: '/profile',
          title: 'Анкета',
          controller: controller,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final response = Completer<Map<String, dynamic>?>();
    when(() => cubit.fetchPage('/profile')).thenAnswer((_) => response.future);

    final first = controller.refresh();
    final second = controller.refresh();
    await tester.pump();
    expect(find.text('Привет из витрины'), findsOneWidget);
    expect(find.byType(MiniAppRunnerSkeleton), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    verify(() => cubit.fetchPage('/profile')).called(2);

    response.complete(null);
    await Future.wait([first, second]);
    await tester.pump();
    expect(find.text('Привет из витрины'), findsOneWidget);
    expect(find.byType(AppBanner), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('server refresh keeps the scroll position', (tester) async {
    final rows = [
      for (var index = 0; index < 60; index++)
        {'type': 'appText', 'data': 'Строка $index'},
    ];
    final scrollScreen = <String, dynamic>{
      'type': 'singleChildScrollView',
      'child': {'type': 'column', 'children': rows},
    };
    final ready = MiniAppRunnerState(
      status: .ready,
      app: _app,
      screen: scrollScreen,
    );
    await _pumpBody(tester, cubit, ready);
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -250),
    );
    await tester.pumpAndSettle();
    final before = tester.state<ScrollableState>(find.byType(Scrollable));
    final offset = before.position.pixels;
    expect(offset, greaterThan(0));

    await _pumpBody(
      tester,
      cubit,
      ready.copyWith(
        screen: {
          ...scrollScreen,
          'child': {
            'type': 'column',
            'children': [
              ...rows,
              {'type': 'appText', 'data': 'Новая строка'},
            ],
          },
        },
      ),
    );
    await tester.pumpAndSettle();

    final after = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(after, same(before));
    expect(after.position.pixels, offset);
  });

  testWidgets('inner reload waits for a fresh response after an active poll', (
    tester,
  ) async {
    when(() => cubit.fetchPage('/profile')).thenAnswer(
      (_) async => {..._screen, 'refreshIntervalSeconds': 5},
    );
    final controller = MiniAppInnerScreenController();
    await tester.pumpApp(
      BlocProvider<MiniAppRunnerCubit>.value(
        value: cubit,
        child: MiniAppInnerScreen(
          path: '/profile',
          title: 'Анкета',
          controller: controller,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final stale = Completer<Map<String, dynamic>?>();
    final fresh = Completer<Map<String, dynamic>?>();
    var requests = 0;
    when(() => cubit.fetchPage('/profile')).thenAnswer(
      (_) => requests++ == 0 ? stale.future : fresh.future,
    );
    await tester.pump(const Duration(seconds: 5));
    var completed = false;
    final foreground = controller.refresh().then((_) => completed = true);
    final repeated = controller.refresh();
    expect(requests, 1);

    stale.complete({'type': 'appText', 'data': 'Старый ответ'});
    await tester.pump();
    expect(requests, 2);
    expect(completed, isFalse);
    expect(find.text('Старый ответ'), findsNothing);
    expect(find.text('Привет из витрины'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    fresh.complete({'type': 'appText', 'data': 'Сохранённая анкета'});
    await foreground;
    await repeated;
    await tester.pumpAndSettle();
    expect(find.text('Сохранённая анкета'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('ignores an old inner response after the path changes', (
    tester,
  ) async {
    final oldResponse = Completer<Map<String, dynamic>?>();
    when(() => cubit.fetchPage('/old')).thenAnswer((_) => oldResponse.future);
    when(() => cubit.fetchPage('/new')).thenAnswer((_) async => _screen);

    Future<void> pumpPath(String path) => tester.pumpApp(
      BlocProvider<MiniAppRunnerCubit>.value(
        value: cubit,
        child: MiniAppInnerScreen(path: path, title: 'Страница'),
      ),
    );

    await pumpPath('/old');
    await pumpPath('/new');
    await tester.pumpAndSettle();
    oldResponse.complete({'type': 'appText', 'data': 'Старый ответ'});
    await tester.pumpAndSettle();

    expect(find.text('Привет из витрины'), findsOneWidget);
    expect(find.text('Старый ответ'), findsNothing);
  });

  testWidgets('inner screen renders a fetched page or a retryable error', (
    tester,
  ) async {
    when(() => cubit.fetchPage('/logic')).thenAnswer((_) async => _screen);
    await tester.pumpApp(
      BlocProvider<MiniAppRunnerCubit>.value(
        value: cubit,
        child: const MiniAppInnerScreen(
          key: ValueKey('inner-logic'),
          path: '/logic',
          title: 'Логика',
          accentColor: '#8064FF',
        ),
      ),
    );
    expect(find.byType(MiniAppRunnerSkeleton), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Привет из витрины'), findsOneWidget);
    expect(find.byType(AppInnerHeader), findsOneWidget);

    when(() => cubit.fetchPage('/missing')).thenAnswer((_) async => null);
    await tester.pumpApp(
      BlocProvider<MiniAppRunnerCubit>.value(
        value: cubit,
        child: const MiniAppInnerScreen(
          key: ValueKey('inner-missing'),
          path: '/missing',
          title: 'Нет',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppErrorState), findsOneWidget);
    await tester.tap(find.text('Повторить'));
    await tester.pump();
    verify(() => cubit.fetchPage('/missing')).called(2);
  });
}
