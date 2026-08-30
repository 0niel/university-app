import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/auth_page_layout.dart';

Widget _app({
  required Widget child,
  bool compact = false,
  bool showBack = true,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, inner) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: textScaler,
        disableAnimations: true,
        accessibleNavigation: true,
      ),
      child: inner!,
    ),
    home: Scaffold(
      body: AuthPageLayout(
        title: 'Welcome back',
        subtitle: 'Use your university account to continue',
        showBack: showBack,
        compact: compact,
        onBack: () {},
        child: child,
      ),
    ),
  );
}

NinjaColors _colorsOf(WidgetTester tester) =>
    tester.element(find.byType(AuthPageLayout)).ninja;

Iterable<BoxDecoration> _decorations(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.byType(DecoratedBox))
    .map((box) => box.decoration)
    .whereType<BoxDecoration>();

void main() {
  testWidgets('remains scrollable with large text on a compact screen', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _app(
        textScaler: const TextScaler.linear(2),
        child: Column(
          children: [
            const NinjaInput(placeholder: 'Email'),
            const SizedBox(height: 12),
            const NinjaInput(placeholder: 'Password'),
            const SizedBox(height: 24),
            NinjaButton.primary(
              key: const Key('continue'),
              label: 'Continue',
              expanded: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.bySemanticsLabel('Back')).shortestSide,
      greaterThanOrEqualTo(NinjaMetrics.minTouchTarget),
    );
    await tester.ensureVisible(find.byKey(const Key('continue')));
    await tester.pump();
    expect(find.byKey(const Key('continue')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('back chrome is a circular 44px surfaceAlt button', (
    tester,
  ) async {
    await tester.pumpWidget(_app(child: const SizedBox.shrink()));
    await tester.pump();

    final colors = _colorsOf(tester);
    expect(
      tester.getSize(find.bySemanticsLabel('Back')),
      const Size(NinjaMetrics.minTouchTarget, NinjaMetrics.minTouchTarget),
    );
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Back'),
        matching: find.byWidgetPredicate((widget) {
          if (widget is! DecoratedBox) return false;
          final decoration = widget.decoration;
          return decoration is BoxDecoration &&
              decoration.shape == BoxShape.circle &&
              decoration.color == colors.surfaceAlt;
        }),
      ),
      findsOneWidget,
    );
  });

  testWidgets('titles stay within display and drop to title when compact', (
    tester,
  ) async {
    await tester.pumpWidget(_app(child: const SizedBox.shrink()));
    await tester.pump();

    expect(
      tester.widget<Text>(find.text('Welcome back')).style?.fontSize,
      NinjaText.display.fontSize,
    );

    await tester.pumpWidget(
      _app(compact: true, child: const SizedBox.shrink()),
    );
    await tester.pump();

    final colors = _colorsOf(tester);
    expect(
      tester.widget<Text>(find.text('Welcome back')).style?.fontSize,
      NinjaText.title.fontSize,
    );
    expect(
      tester
          .widget<Text>(
            find.text('Use your university account to continue'),
          )
          .style
          ?.fontSize,
      NinjaText.body.fontSize,
    );
    expect(
      _decorations(
        tester,
      ).where((decoration) => decoration.color == colors.accentSoft),
      isEmpty,
    );
  });
}
