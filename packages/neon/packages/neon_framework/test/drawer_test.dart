import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/apps.dart';
import 'package:neon_framework/src/blocs/capabilities.dart';
import 'package:neon_framework/src/models/app_implementation.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/drawer.dart';
import 'package:neon_framework/src/widgets/drawer_destination.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:rxdart/rxdart.dart';

class MockAccountsBloc extends Mock implements AccountsBloc {}

class MockAppsBloc extends Mock implements AppsBloc {}

class MockCapabilitiesBloc extends Mock implements CapabilitiesBloc {}

// ignore: missing_override_of_must_be_overridden, avoid_implementing_value_types
class MockAppImplementation extends Mock implements AppImplementation {}

class BuildContextFake extends Fake implements BuildContext {}

void main() {
  setUpAll(() {
    registerFallbackValue(BuildContextFake());
  });

  testWidgets('Drawer', (tester) async {
    final appImplementation = MockAppImplementation();
    when(() => appImplementation.id).thenReturn('id');
    when(() => appImplementation.destination(any())).thenReturn(
      NeonNavigationDestination(
        label: 'label',
        // ignore: avoid_types_on_closure_parameters
        icon: ({size, Color? color}) => Icon(
          Icons.add,
          size: size,
          color: color,
        ),
      ),
    );

    final appImplementations = BehaviorSubject<Result<Iterable<AppImplementation>>>();
    final activeApp = BehaviorSubject<AppImplementation>();
    final appsBloc = MockAppsBloc();
    when(() => appsBloc.activeApp).thenAnswer((_) => activeApp);
    when(() => appsBloc.appImplementations).thenAnswer((_) => appImplementations);

    final capabilities =
        BehaviorSubject<Result<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data>>.seeded(Result.error(null));
    final capabilitiesBloc = MockCapabilitiesBloc();
    when(() => capabilitiesBloc.capabilities).thenAnswer((_) => capabilities);

    final accountsBloc = MockAccountsBloc();
    when(() => accountsBloc.activeAppsBloc).thenReturn(appsBloc);
    when(() => accountsBloc.activeCapabilitiesBloc).thenReturn(capabilitiesBloc);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: NeonLocalizations.localizationsDelegates,
        supportedLocales: NeonLocalizations.supportedLocales,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: NeonProvider<AccountsBloc>.value(
            value: accountsBloc,
            child: const NeonDrawer(),
          ),
        ),
      ),
    );

    expect(find.byType(NeonDrawerHeader), findsOne);
    expect(find.byType(NavigationDrawerDestination), findsOne);

    activeApp.add(appImplementation);
    appImplementations.add(Result.success([appImplementation]));

    await tester.pumpAndSettle();

    expect(find.byType(NavigationDrawerDestination), findsExactly(2));
    expect(find.text('label'), findsOne);
    expect(find.byIcon(Icons.add), findsOne);

    unawaited(capabilities.close());
    unawaited(activeApp.close());
    unawaited(appImplementations.close());
  });
}
