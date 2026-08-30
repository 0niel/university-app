import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/services/view/services_section_skeleton.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('mirrors a section label and its tile grid', (tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: SingleChildScrollView(child: ServicesSectionSkeleton()),
      ),
    );

    expect(find.bySemanticsLabel('Загрузка'), findsOneWidget);
    expect(find.byType(NinjaSkeleton), findsNWidgets(17));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('keeps two readable columns at 320px and 200% text', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: SingleChildScrollView(
          child: ServicesSectionSkeleton(tileCount: 4),
        ),
      ),
      size: const Size(320, 900),
      textScaler: const TextScaler.linear(2),
    );

    expect(tester.takeException(), isNull);
    final tiles = find.byWidgetPredicate(
      (widget) => widget is NinjaSkeleton && widget.width == 56,
    );
    expect(tiles, findsNWidgets(4));
    expect(
      tester.getTopLeft(tiles.at(0)).dy,
      tester.getTopLeft(tiles.at(1)).dy,
    );
    expect(
      tester.getTopLeft(tiles.at(2)).dy,
      greaterThan(tester.getTopLeft(tiles.at(0)).dy),
    );
  });
}
