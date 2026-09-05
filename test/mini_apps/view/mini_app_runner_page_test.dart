import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_inner_screen.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_page.dart';
import 'package:stac_bridge/stac_bridge.dart';

import '../../helpers/pump_app.dart';

class _Repository extends Mock implements MiniAppsRepository {}

void main() {
  testWidgets('refreshes the active page without pushing another route', (
    tester,
  ) async {
    final repository = _Repository();
    const app = MiniApp(id: 'app-1', slug: 'poll', name: 'Опрос');
    const profile = <String, dynamic>{
      'type': 'appInputField',
      'id': 'name',
      'label': 'Имя',
      'initialValue': 'Начальное имя',
    };
    when(() => repository.getApp('poll')).thenAnswer((_) async => app);
    when(() => repository.getStorage('app-1')).thenAnswer((_) async => {});
    when(
      () => repository.readCachedScreen(slug: 'poll'),
    ).thenAnswer((_) async => null);
    when(() => repository.fetchScreen(slug: 'poll')).thenAnswer(
      (_) async => {'type': 'appText', 'data': 'Главная'},
    );
    when(
      () => repository.fetchScreen(slug: 'poll', path: '/profile'),
    ).thenAnswer((_) async => profile);

    await tester.pumpApp(
      RepositoryProvider<MiniAppsRepository>.value(
        value: repository,
        child: MiniAppRunnerPage(
          slug: 'poll',
          runtimeInitializerBuilder: () => StacBridge.ensureInitialized(
            StacBridgeConfig(
              proxyUrl: 'https://example.test/proxy',
              organizationId: 'mirea',
              onAccessTokenRequested: () async => null,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final host = MiniAppSessionStack.current!.host;
    final opening = host.openPage(path: '/profile');
    await tester.pumpAndSettle();
    await opening;
    await tester.enterText(find.byType(TextField), 'Сохранённый ввод');
    final before = tester.widget<TextField>(find.byType(TextField)).controller;

    final reopening = host.openPage(path: '/profile');
    await tester.pumpAndSettle();
    await reopening;
    expect(
      find.byType(MiniAppInnerScreen, skipOffstage: false),
      findsOneWidget,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller,
      same(before),
    );
    expect(before!.text, 'Сохранённый ввод');

    await host.reload();
    await tester.pumpAndSettle();
    verify(() => repository.fetchScreen(slug: 'poll')).called(1);
    verify(
      () => repository.fetchScreen(slug: 'poll', path: '/profile'),
    ).called(3);

    Navigator.of(tester.element(find.byType(MiniAppInnerScreen))).pop();
    await host.reload();
    await tester.pumpAndSettle();
    verify(() => repository.fetchScreen(slug: 'poll')).called(1);
    expect(find.text('Главная'), findsOneWidget);
  });

  testWidgets('root reload closes owned pages without leaving the mini app', (
    tester,
  ) async {
    final repository = _Repository();
    const app = MiniApp(id: 'app-1', slug: 'poll', name: 'Опрос');
    when(() => repository.getApp('poll')).thenAnswer((_) async => app);
    when(() => repository.getStorage('app-1')).thenAnswer((_) async => {});
    when(
      () => repository.readCachedScreen(slug: 'poll'),
    ).thenAnswer((_) async => null);
    when(
      () => repository.fetchScreen(
        slug: 'poll',
        path: any(named: 'path'),
      ),
    ).thenAnswer(
      (call) async => {
        'type': 'appText',
        'data': call.namedArguments[#path] ?? 'Главная',
      },
    );

    await tester.pumpApp(
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => unawaited(
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => RepositoryProvider<MiniAppsRepository>.value(
                    value: repository,
                    child: MiniAppRunnerPage(
                      slug: 'poll',
                      runtimeInitializerBuilder: () =>
                          StacBridge.ensureInitialized(
                            StacBridgeConfig(
                              proxyUrl: 'https://example.test/proxy',
                              organizationId: 'mirea',
                              onAccessTokenRequested: () async => null,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),
            child: const Text('Открыть мини-приложение'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Открыть мини-приложение'));
    await tester.pumpAndSettle();
    final host = MiniAppSessionStack.current!.host;
    for (final path in ['/matches', '/match']) {
      final opening = host.openPage(path: path);
      await tester.pumpAndSettle();
      await opening;
    }
    expect(
      find.byType(MiniAppInnerScreen, skipOffstage: false),
      findsNWidgets(2),
    );

    await host.reloadRoot();
    await tester.pumpAndSettle();

    expect(find.byType(MiniAppInnerScreen, skipOffstage: false), findsNothing);
    expect(find.text('Главная'), findsOneWidget);
    expect(find.byType(MiniAppRunnerPage), findsOneWidget);
    expect(find.text('Открыть мини-приложение'), findsNothing);
    verify(() => repository.fetchScreen(slug: 'poll')).called(2);
    expect(
      Navigator.of(tester.element(find.byType(MiniAppRunnerPage))).canPop(),
      isTrue,
    );
  });

  testWidgets('shows a retry action when runtime initialization fails', (
    tester,
  ) async {
    var attempts = 0;
    final retryCompleter = Completer<void>();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MiniAppRunnerPage(
          slug: 'test-app',
          runtimeInitializerBuilder: () {
            attempts += 1;
            if (attempts == 1) return Future<void>.error(Exception('boom'));
            return retryCompleter.future;
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Повторить'), findsOneWidget);
    expect(attempts, 1);

    await tester.tap(find.text('Повторить'));
    await tester.pump();
    await tester.pump();

    expect(attempts, 2);
    expect(retryCompleter.isCompleted, isFalse);
  });
}
