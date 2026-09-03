import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

const _steps = [
  AppTourStep(
    title: 'Поиск по всему кампусу',
    body: 'Из шапки любого корневого экрана.',
    target: AppTourTarget.homeSearch,
    location: '/a',
  ),
  AppTourStep(
    title: 'Твой путь ниндзя',
    body: 'Опыт, серия дней и достижения.',
    target: AppTourTarget.profileStats,
    location: '/b',
  ),
];

class _Screen extends StatelessWidget {
  const _Screen({required this.target, required this.label});

  final AppTourTarget target;
  final String label;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: AppTourAnchor(
        target: target,
        child: SizedBox(height: 48, width: 200, child: Text(label)),
      ),
    ),
  );
}

Widget _app(
  GoRouter router,
  AppTourController controller, {
  TextStyle? outerTextStyle,
}) => MaterialApp.router(
  locale: const Locale('ru'),
  theme: AppTheme.lightTheme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  routerConfig: router,
  builder: (context, child) {
    final overlay = AppTourOverlay(
      router: router,
      controller: controller,
      child: child ?? const SizedBox.shrink(),
    );
    final style = outerTextStyle;
    return style == null
        ? overlay
        : DefaultTextStyle(style: style, child: overlay);
  },
);

Future<void> _advance(WidgetTester tester) async {
  for (var tick = 0; tick < 24; tick++) {
    await tester.pump(const Duration(milliseconds: 40));
  }
}

void main() {
  late AppTourController controller;
  late GoRouter router;

  setUp(() {
    controller = AppTourController(
      anchorTimeout: const Duration(milliseconds: 400),
    );
    router = GoRouter(
      initialLocation: '/a',
      routes: [
        GoRoute(
          path: '/a',
          builder: (_, _) => const _Screen(
            target: AppTourTarget.homeSearch,
            label: 'Экран А',
          ),
        ),
        GoRoute(
          path: '/b',
          builder: (_, _) => const _Screen(
            target: AppTourTarget.profileStats,
            label: 'Экран Б',
          ),
        ),
      ],
    );
  });

  tearDown(() {
    controller
      ..stop()
      ..dispose();
    router.dispose();
  });

  testWidgets('stays out of the way until the tour starts', (tester) async {
    await tester.pumpWidget(_app(router, controller));
    await tester.pump();

    expect(find.byType(TourCoachCard), findsNothing);
    expect(find.byType(NinjaSpotlight), findsNothing);
    expect(find.text('Экран А'), findsOneWidget);
  });

  testWidgets('spotlights the widget the step points at', (tester) async {
    await tester.pumpWidget(_app(router, controller));
    await tester.pump();

    unawaited(controller.start(_steps));
    await _advance(tester);

    expect(find.text('Поиск по всему кампусу'), findsOneWidget);
    expect(find.byType(TourCoachCard), findsOneWidget);
    expect(find.text('1 ИЗ 2'), findsOneWidget);
    expect(find.text('Далее'), findsOneWidget);
    expect(find.text('Пропустить'), findsOneWidget);

    final spotlight = tester.widget<NinjaSpotlight>(
      find.byType(NinjaSpotlight),
    );
    final anchor = tester.getRect(find.text('Экран А'));
    expect(spotlight.hole, isNotNull);
    expect(spotlight.hole!.inflate(-8), anchor);
  });

  testWidgets('coach copy clears the outer fallback text decoration', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        router,
        controller,
        outerTextStyle: const TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Colors.yellow,
          decorationStyle: TextDecorationStyle.double,
        ),
      ),
    );
    await tester.pump();

    unawaited(controller.start(_steps));
    await tester.pump();

    final finder = find.text('Поиск по всему кампусу');
    final text = tester.widget<Text>(finder);
    final inherited = DefaultTextStyle.of(tester.element(finder)).style;
    expect(inherited.merge(text.style).decoration, TextDecoration.none);
    controller.stop();
    await _advance(tester);
  });

  testWidgets('keeps the old callout and spotlight during route resolution', (
    tester,
  ) async {
    await tester.pumpWidget(_app(router, controller));
    await tester.pump();
    unawaited(controller.start(_steps));
    await _advance(tester);
    final firstHole = tester
        .widget<NinjaSpotlight>(find.byType(NinjaSpotlight))
        .hole;

    await tester.tap(find.text('Далее'));
    await tester.pump(const Duration(milliseconds: 16));

    expect(controller.isMoving, isTrue);
    expect(find.text('Поиск по всему кампусу'), findsOneWidget);
    expect(find.text('Твой путь ниндзя'), findsNothing);
    expect(
      tester.widget<NinjaSpotlight>(find.byType(NinjaSpotlight)).hole,
      firstHole,
    );
    controller.stop();
    await _advance(tester);
  });

  testWidgets('walks to the screen the next step lives on', (tester) async {
    await tester.pumpWidget(_app(router, controller));
    await tester.pump();

    unawaited(controller.start(_steps));
    await _advance(tester);
    await tester.tap(find.text('Далее'));
    await _advance(tester);

    expect(find.text('Экран Б'), findsOneWidget);
    expect(find.text('Твой путь ниндзя'), findsOneWidget);
    expect(find.text('2 ИЗ 2'), findsOneWidget);
    expect(find.text('Готово'), findsOneWidget);

    final spotlight = tester.widget<NinjaSpotlight>(
      find.byType(NinjaSpotlight),
    );
    expect(spotlight.hole!.inflate(-8), tester.getRect(find.text('Экран Б')));
  });

  testWidgets('finishing the last step closes the tour', (tester) async {
    await tester.pumpWidget(_app(router, controller));
    await tester.pump();

    unawaited(controller.start(_steps));
    await _advance(tester);
    await tester.tap(find.text('Далее'));
    await _advance(tester);
    await tester.tap(find.text('Готово'));
    await _advance(tester);

    expect(find.byType(TourCoachCard), findsNothing);
    expect(controller.isActive, isFalse);
  });

  testWidgets('skipping leaves the app untouched', (tester) async {
    await tester.pumpWidget(_app(router, controller));
    await tester.pump();

    unawaited(controller.start(_steps));
    await _advance(tester);
    await tester.tap(find.text('Пропустить'));
    await _advance(tester);

    expect(find.byType(TourCoachCard), findsNothing);
    expect(find.byType(NinjaSpotlight), findsNothing);
    expect(find.text('Экран А'), findsOneWidget);
    expect(controller.isActive, isFalse);
  });

  testWidgets('a system back press leaves the tour, not the screen', (
    tester,
  ) async {
    await tester.pumpWidget(_app(router, controller));
    await tester.pump();

    unawaited(controller.start(_steps));
    await _advance(tester);
    await tester.binding.handlePopRoute();
    await _advance(tester);

    expect(controller.isActive, isFalse);
    expect(find.byType(TourCoachCard), findsNothing);
    expect(find.text('Экран А'), findsOneWidget);
  });

  testWidgets('a tap on the scrim moves to the next step', (tester) async {
    await tester.pumpWidget(_app(router, controller));
    await tester.pump();

    unawaited(controller.start(_steps));
    await _advance(tester);
    await tester.tapAt(const Offset(10, 10));
    await _advance(tester);

    expect(find.text('Твой путь ниндзя'), findsOneWidget);
  });

  testWidgets('tapping callout copy does not advance the tour', (tester) async {
    await tester.pumpWidget(_app(router, controller));
    await tester.pump();

    unawaited(controller.start(_steps));
    await _advance(tester);
    await tester.tap(find.text('Поиск по всему кампусу'));
    await tester.pump(const Duration(milliseconds: 160));

    expect(controller.index, 0);
    expect(find.text('Экран А'), findsOneWidget);
  });
}
