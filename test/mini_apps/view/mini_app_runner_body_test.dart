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
