import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_progress_bar.dart';

void main() {
  Widget wrap(Widget child, {double textScale = 1, bool pastel = false}) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ColoredBox(
                color: pastel
                    ? context.ninja.accentSoft
                    : context.ninja.surface,
                child: SizedBox(width: 240, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> fillsOf(WidgetTester tester) => tester
      .widgetList<ColoredBox>(
        find.descendant(
          of: find.byType(ProfileProgressBar),
          matching: find.byType(ColoredBox),
        ),
      )
      .map((box) => box.color)
      .toList();

  testWidgets('draws an 8 px pill on surface cards', (tester) async {
    await tester.pumpWidget(
      wrap(const ProfileProgressBar(value: 0.5, label: '50%')),
    );
    await tester.pumpAndSettle();

    final colors = tester.element(find.byType(ProfileProgressBar)).ninja;
    final track = tester.widget<SizedBox>(
      find
          .descendant(
            of: find.byType(ProfileProgressBar),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    final clip = tester.widget<ClipRRect>(
      find.descendant(
        of: find.byType(ProfileProgressBar),
        matching: find.byType(ClipRRect),
      ),
    );

    expect(track.height, 8);
    expect(clip.borderRadius, BorderRadius.circular(NinjaRadius.pill));
    expect(fillsOf(tester), [colors.surfaceAlt, colors.brand]);
  });

  testWidgets('inverts the palette on the pastel feature card', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ProfileProgressBar(value: 0.25, label: '25%', pastel: true),
        pastel: true,
      ),
    );
    await tester.pumpAndSettle();

    final colors = tester.element(find.byType(ProfileProgressBar)).ninja;
    expect(fillsOf(tester), [
      const Color(0x8CFFFFFF),
      colors.onAccentSoft,
    ]);
    expect(
      tester.widget<Text>(find.text('25%')).style?.color,
      colors.onAccentSoft,
    );
  });

  testWidgets('keeps the percent in tabular figures', (tester) async {
    await tester.pumpWidget(
      wrap(const ProfileProgressBar(value: 0.9, label: '90%')),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.text('90%')).style?.fontFeatures,
      contains(const FontFeature.tabularFigures()),
    );
  });

  testWidgets('stacks the label under the bar at 200 percent text', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ProfileProgressBar(value: 0.4, label: '40%'),
        textScale: 2,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(ProfileProgressBar),
        matching: find.byType(Row),
      ),
      findsNothing,
    );
    expect(
      tester.getTopLeft(find.text('40%')).dy,
      greaterThan(tester.getTopLeft(find.byType(ClipRRect)).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
