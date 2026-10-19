import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/services/services.dart';

import '../../helpers/pump_app.dart';

void main() {
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

  testWidgets('default shortcuts resolve to the registered routes in order', (
    tester,
  ) async {
    late List<ServiceModel> services;
    await tester.pumpApp(
      Builder(
        builder: (context) {
          services = ServicesConfig.getHomeServices(context, config);
          return const SizedBox();
        },
      ),
    );

    final routes = [
      const DeadlinesRoute().location,
      const EventsRoute().location,
      const FriendsRoute().location,
      const MarketplaceRoute().location,
      const LostAndFoundRoute().location,
      const CommunitiesRoute().location,
      const PollsRoute().location,
      const PeopleRoute().location,
    ];
    expect(HomeServiceDefaults.routes, routes);
    expect(services.map((service) => service.routePath), routes);
    expect(services.every((service) => !service.isExternal), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'ordered selection keeps custom order and ignores absent entries',
    (
      tester,
    ) async {
      late List<ServiceEntry> entries;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            entries = ServicesDirectory.all(context, config);
            return const SizedBox();
          },
        ),
      );
      const external = ServiceEntry(
        model: ServiceModel(
          title: 'External',
          icon: AppLineIcon.globe,
          color: Color(0xFF086A81),
          url: 'https://example.test/tool',
        ),
        subtitle: '',
      );
      const ids = [
        '/services/people',
        'https://example.test/tool',
        '/services/deadlines',
        '/services/unavailable',
      ];
      final selected = ServicesDirectory.orderedEntries([
        ...entries.reversed,
        external,
        ...entries,
      ], ids);

      expect(selected.map((entry) => entry.id), ids.take(3));
      expect(
        selected.where((entry) => entry.model.isExternal).single,
        external,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
