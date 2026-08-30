import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_services_rail.dart';
import 'package:rtu_mirea_app/services/services.dart';

import '../../helpers/pump_app.dart';

void main() {
  const config = UniversityConfig(
    organizationId: 'example-university',
    appName: 'Example App',
    universityName: 'Example University',
    universityShortName: 'EU',
    websiteUrl: 'https://university.example',
    supportEmail: 'support@university.example',
    deepLinkScheme: 'exampleapp',
    webAppHost: 'app.university.example',
    webAppPathPrefix: '/app',
    enabledCapabilities: {},
  );

  test('favorites lead and fallback fills the home selection', () {
    ServiceModel service(String path) => ServiceModel(
      title: path,
      icon: AppLineIcon.grid,
      color: Colors.blue,
      isExternal: false,
      routePath: path,
    );
    final all = [service('/a'), service('/b'), service('/c')];
    final defaults = [service('/c'), service('/a')];

    final result = homeServiceSelection(
      all: all,
      defaults: defaults,
      favoriteIds: {'/b'},
    );

    expect(result.map((service) => service.routePath), ['/b', '/c', '/a']);
  });

  testWidgets('rail is horizontally scrollable on a narrow large-text screen', (
    tester,
  ) async {
    final favorites = FavoriteServicesCubit();
    addTearDown(favorites.close);

    await tester.pumpApp(
      BlocProvider.value(
        value: favorites,
        child: const HomeServicesRail(config: config),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );

    expect(tester.takeException(), isNull);
    final list = tester.widget<ListView>(
      find.byKey(const ValueKey('home-services-rail')),
    );
    expect(list.scrollDirection, Axis.horizontal);
    expect(list.physics, isA<BouncingScrollPhysics>());
    expect(find.text('Свободные аудитории'), findsOneWidget);
  });
}
