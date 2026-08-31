import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Ninja API exposes theme, palette, widgets, and surfaces', (
    tester,
  ) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const Scaffold(
              body: Column(
                children: [
                  NinjaButton(label: 'Продолжить'),
                  NinjaCard(child: Text('Карточка')),
                  NinjaSkeleton.bar(shimmer: false),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(capturedContext.ninja, isA<NinjaColors>());
    expect(capturedContext.ninja.ninjaOnScarlet, isA<Color>());
    expect(NinjaText.title.fontFamily, NinjaText.family);
    expect(
      [
        NinjaText.display,
        NinjaText.title,
        NinjaText.appBarTitle,
        NinjaText.headline,
        NinjaText.dialogTitle,
        NinjaText.body,
        NinjaText.subtext,
        NinjaText.microLabel,
        NinjaText.badge,
        NinjaText.button,
        NinjaText.buttonLarge,
        NinjaText.buttonSmall,
        NinjaText.helper,
      ].map((style) => style.decoration),
      everyElement(TextDecoration.none),
    );
    expect(NinjaRadius.card, 24);
    expect(NinjaRadius.button, NinjaRadius.pill);
    expect(NinjaMetrics.minTouchTarget, 44);
    expect(NinjaButtonVariant.primary.name, 'primary');
    expect(NinjaActionTone.ink.name, 'ink');
    expect(find.byType(NinjaButton), findsOneWidget);
    expect(find.byType(NinjaCard), findsOneWidget);
    expect(find.byType(NinjaSkeleton), findsOneWidget);
  });

  test('subject accents stay deterministic and avoid semantic danger', () {
    final colors = NinjaColors.light();
    final palette = colors.subjectPalette;

    expect(
      colors.mireaAccentPalette,
      const [
        Color(0xFFB26497),
        Color(0xFFEB7225),
        Color(0xFFB4462A),
        Color(0xFF731E6C),
        Color(0xFFEBB804),
        Color(0xFF086A81),
        Color(0xFF047A35),
        Color(0xFF706F6F),
      ],
    );
    expect(palette, hasLength(8));
    expect(palette.toSet(), hasLength(8));
    expect(palette, isNot(contains(colors.scarlet)));
    expect(colors.subjectColor('Математика'), isIn(palette));
    expect(
      colors.subjectColor('Математика'),
      colors.subjectColor('Математика'),
    );
  });

  test('subject accents keep visible glyphs on soft focal fills', () {
    for (final colors in [NinjaColors.light(), NinjaColors.dark()]) {
      for (final baseAccent in colors.mireaAccentPalette) {
        final accent = colors.accentInk(baseAccent);
        final fill = Color.alphaBlend(
          baseAccent.withValues(alpha: colors.isDark ? 0.24 : 0.14),
          colors.surface,
        );
        expect(
          _contrastRatio(accent, colors.canvas),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrastRatio(accent, colors.surface),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrastRatio(accent, colors.surfaceAlt),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrastRatio(colors.accentOn(baseAccent, fill), fill),
          greaterThanOrEqualTo(4.5),
        );
        expect(_contrastRatio(colors.ink, fill), greaterThanOrEqualTo(4.5));
      }
    }
  });
}

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter =
      firstLuminance > secondLuminance ? firstLuminance : secondLuminance;
  final darker =
      firstLuminance > secondLuminance ? secondLuminance : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}
