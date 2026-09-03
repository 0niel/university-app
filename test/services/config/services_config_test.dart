import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/services/config/services_config.dart';

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

  testWidgets('hides university-specific services when capabilities are off', (
    tester,
  ) async {
    late final List<String> importantPaths;
    late final List<String> usefulPaths;

    await tester.pumpApp(
      Builder(
        builder: (context) {
          importantPaths = [
            for (final service in ServicesConfig.getImportantServices(
              context,
              config,
            ))
              service.routePath!,
          ];
          usefulPaths = [
            for (final service in ServicesConfig.getUsefulServices(
              context,
              config,
            ))
              service.routePath!,
          ];
          return const SizedBox();
        },
      ),
    );

    expect(importantPaths, isEmpty);
    expect(usefulPaths, ['/services/apps']);
  });

  testWidgets('built-in services use unique and valid destinations', (
    tester,
  ) async {
    late final List<String> destinations;

    await tester.pumpApp(
      Builder(
        builder: (context) {
          destinations = [
            for (final service in ServicesConfig.getAllBuiltInServices(
              context,
              config,
            ))
              service.routePath ?? service.url!,
          ];
          return const SizedBox();
        },
      ),
    );

    expect(destinations, contains('/services/free-rooms'));
    expect(destinations, isNot(contains('/services/apps/free-rooms/run')));
    expect(destinations.toSet(), hasLength(destinations.length));
    expect(
      destinations.where((value) => value.startsWith('/')),
      everyElement(
        anyOf(
          equals('/schedule'),
          startsWith('/schedule/'),
          startsWith('/profile/'),
          startsWith('/feed/'),
          startsWith('/services/'),
        ),
      ),
    );
  });

  testWidgets('core catalog has meaningful non-empty sections', (
    tester,
  ) async {
    late final List<int> sectionSizes;

    await tester.pumpApp(
      Builder(
        builder: (context) {
          sectionSizes = [
            ServicesConfig.getMainServices(context).length,
            ServicesConfig.getStudentLifeServices(context).length,
            ServicesConfig.getCommunityServices(context).length,
            ServicesConfig.getUsefulServices(context, config).length,
          ];
          return const SizedBox();
        },
      ),
    );

    expect(sectionSizes, everyElement(greaterThanOrEqualTo(1)));
  });
}
