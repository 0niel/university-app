import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final first = DateTime(2026, 6);
  final days = [
    for (var index = 0; index < 126; index++)
      AppHeatmapDay(
        date: first.add(Duration(days: index)),
        count: index,
      ),
  ];
  final last = days.last.date;
  String message(DateTime day, int count) =>
      '${day.toIso8601String()} · $count';
  Widget wrap(Widget child) => MaterialApp(
    theme: AppTheme.darkTheme.copyWith(
      tooltipTheme: const TooltipThemeData(
        waitDuration: Duration(milliseconds: 50),
        showDuration: Duration(milliseconds: 500),
      ),
    ),
    home: Scaffold(
      body: Center(child: SizedBox(width: 340, child: child)),
    ),
  );
  Widget heatmap() => AppActivityHeatmap(
    days: days,
    today: last,
    tooltipBuilder: message,
  );
  int routeCount() =>
      GestureBinding.instance.pointerRouter.debugGlobalRouteCount;
  Finder cell(DateTime day) => find.byKey(ValueKey(day));

  testWidgets('tooltip targets preserve every rendered cell pixel', (
    tester,
  ) async {
    final boundary = GlobalKey();
    Future<List<int>?> pixels() => tester.runAsync(() async {
      final image = await tester
          .renderObject<RenderRepaintBoundary>(find.byKey(boundary))
          .toImage(pixelRatio: 2);
      try {
        final bytes = await image.toByteData();
        return bytes!.buffer.asUint8List();
      } finally {
        image.dispose();
      }
    });
    await tester.pumpWidget(
      wrap(
        RepaintBoundary(
          key: boundary,
          child: AppActivityHeatmap(days: days, today: last),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final plain = await pixels();
    expect(plain, isNotNull);
    await tester.pumpWidget(
      wrap(RepaintBoundary(key: boundary, child: heatmap())),
    );
    await tester.pumpAndSettle();
    expect(await pixels(), orderedEquals(plain!));
    expect(tester.takeException(), isNull);
  });

  testWidgets('126 cells preserve semantics with at most one global route', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(wrap(const SizedBox()));
    final baseline = routeCount();
    await tester.pumpWidget(wrap(heatmap()));
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.tooltip?.contains('T00:00:00.000') == true,
      ),
      findsNWidgets(126),
    );
    expect(routeCount(), lessThanOrEqualTo(baseline + 1));
    expect(find.byType(Tooltip), findsNothing);
    expect(
      tester.getSemantics(cell(last)).getSemanticsData().tooltip,
      message(last, 125),
    );
    await tester.longPress(cell(last));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(message(last, 125)), findsOneWidget);
    expect(routeCount(), lessThanOrEqualTo(baseline + 1));
    expect(tester.getRect(find.byType(Tooltip)), tester.getRect(cell(last)));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(Tooltip), findsNothing);
    expect(routeCount(), baseline);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('hover follows the correct cell and retains its real anchor', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(heatmap()));
    final baseline = routeCount();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(cell(first)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(message(first, 0)), findsOneWidget);
    expect(routeCount(), lessThanOrEqualTo(baseline + 1));
    expect(tester.getRect(find.byType(Tooltip)), tester.getRect(cell(first)));
    await mouse.moveTo(tester.getCenter(cell(last)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(message(first, 0)), findsNothing);
    expect(find.text(message(last, 125)), findsOneWidget);
    expect(tester.getRect(find.byType(Tooltip)), tester.getRect(cell(last)));
    expect(routeCount(), lessThanOrEqualTo(baseline + 1));
    await mouse.moveTo(Offset.zero);
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(message(last, 125)), findsNothing);
    await mouse.removePointer();
    await tester.pumpWidget(wrap(const SizedBox()));
    expect(routeCount(), baseline);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'disposing a shown tooltip removes routes and delayed callbacks',
    (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const SizedBox()));
      final baseline = routeCount();
      await tester.pumpWidget(wrap(heatmap()));
      await tester.longPress(cell(last));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text(message(last, 125)), findsOneWidget);
      await tester.pumpWidget(wrap(const SizedBox()));
      expect(routeCount(), baseline);
      await tester.pump(const Duration(seconds: 2));
      expect(routeCount(), baseline);
      expect(tester.takeException(), isNull);
    },
  );
}
