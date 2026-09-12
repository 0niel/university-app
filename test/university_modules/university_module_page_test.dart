import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/university_modules/university_module_page.dart';
import 'package:university_modules/university_modules.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/pump_app.dart';

class _AppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _Module implements UniversityModule {
  @override
  ModuleDescriptor get descriptor => const ModuleDescriptor(
    id: 'campus-services',
    title: 'Campus services',
    description: 'Services',
    organizationIds: {'university-a'},
  );

  ModuleHost? lastHost;

  @override
  Widget build(ModuleHost host) {
    lastHost = host;
    return Text('account:${host.accountId}');
  }
}

void main() {
  const config = UniversityConfig(
    organizationId: 'university-a',
    appName: 'University',
    universityName: 'University A',
    universityShortName: 'UA',
    websiteUrl: 'https://university.example',
    supportEmail: 'support@university.example',
    deepLinkScheme: 'university',
    webAppHost: 'university.example',
    webAppPathPrefix: '/app',
  );

  Widget page(ModuleRegistry registry, {String id = 'campus-services'}) =>
      RepositoryProvider.value(
        value: config,
        child: UniversityModulePage(moduleId: id, registry: registry),
      );

  testWidgets('an unknown module deep link displays an unavailable state', (
    tester,
  ) async {
    await tester.pumpApp(page(ModuleRegistry([]), id: 'not-installed'));

    expect(find.text('Модуль недоступен'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an unauthenticated route cannot construct the module', (
    tester,
  ) async {
    final module = _Module();
    final app = _AppBloc();
    when(() => app.state).thenReturn(const AppState());
    await tester.pumpApp(
      BlocProvider<AppBloc>.value(
        value: app,
        child: page(ModuleRegistry([module])),
      ),
    );

    expect(find.text('Войдите в приложение'), findsOneWidget);
    expect(module.lastHost, isNull);
  });

  testWidgets('changing the application account replaces the module host', (
    tester,
  ) async {
    final module = _Module();
    final app = _AppBloc();
    const initial = AppState(
      status: AppStatus.authenticated,
      user: User(id: 'student-a'),
    );
    final states = StreamController<AppState>();
    addTearDown(states.close);
    whenListen(app, states.stream, initialState: initial);
    when(() => app.isClosed).thenReturn(false);
    final registry = ModuleRegistry([module]);

    Future<void> pump() => tester.pumpApp(
      BlocProvider<AppBloc>.value(
        value: app,
        child: page(registry),
      ),
    );
    await pump();
    final previous = module.lastHost!;
    expect(find.text('account:student-a'), findsOneWidget);

    states.add(
      const AppState(
        status: AppStatus.authenticated,
        user: User(id: 'student-b'),
      ),
    );
    await tester.pump();
    expect(find.text('account:student-b'), findsOneWidget);
    expect(module.lastHost, isNot(same(previous)));
    await expectLater(previous.readSecure('session'), throwsException);
  });
}
