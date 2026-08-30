import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/services/view/services_drop_group.dart';
import 'package:rtu_mirea_app/services/view/services_grid.dart';
import 'package:rtu_mirea_app/services/view/services_grid_tile.dart';

void main() {
  final services = List.generate(
    4,
    (index) => ServiceModel(
      title: 'Очень длинный сервис $index',
      icon: AppLineIcon.book,
      color: index.isEven ? const Color(0xFF6C63FF) : const Color(0xFFFFB300),
      routePath: '/service/$index',
    ),
  );

  Widget buildSubject(Widget child) => MaterialApp(
    theme: NinjaTheme.light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: const MediaQueryData(
        size: Size(320, 700),
        textScaler: TextScaler.linear(2),
        accessibleNavigation: true,
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );

  testWidgets('uses two readable columns at 320px and 200% text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 700);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      buildSubject(
        ServicesGrid(
          services: services,
          editMode: false,
          onFavoriteCheck: (_) => false,
          onServiceTap: (_) {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final tiles = tester
        .widgetList<ServicesGridTile>(find.byType(ServicesGridTile))
        .toList();
    expect(tiles, hasLength(4));
    expect(find.byType(AppServiceTile), findsNWidgets(4));
    expect(find.byType(AppLineIconWidget), findsNWidgets(4));
    expect(find.byType(Icon), findsNothing);
    final first = tester.getTopLeft(find.byType(ServicesGridTile).at(0));
    final second = tester.getTopLeft(find.byType(ServicesGridTile).at(1));
    final third = tester.getTopLeft(find.byType(ServicesGridTile).at(2));
    expect(first.dy, second.dy);
    expect(third.dy, greaterThan(first.dy));
  });

  testWidgets('disables drop feedback motion for accessible navigation', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        ServicesDropGroup(
          groupKey: 'main',
          services: services,
          draggable: true,
          editMode: true,
          onFavoriteCheck: (_) => false,
          onServiceTap: (_) {},
          onMoveService: (_, _, {beforeId}) {},
        ),
      ),
    );

    final containers = tester.widgetList<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect(
      containers.any((widget) => widget.duration == Duration.zero),
      isTrue,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.selected == false &&
            widget.properties.label?.startsWith('Очень длинный сервис') == true,
      ),
      findsNWidgets(4),
    );
    expect(tester.takeException(), isNull);
  });
}
