import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_pass_card.dart';

void main() {
  for (final brightness in Brightness.values) {
    final theme = brightness == Brightness.light
        ? AppTheme.lightTheme
        : AppTheme.darkTheme;

    test('${brightness.name} scrim contrasts with a white photo', () {
      final colors = theme.extension<AppColors>()!;
      final background = Color.alphaBlend(
        colors.scrim.withValues(alpha: NfcPassCard.textScrimOpacity),
        Colors.white,
      );

      expect(_contrast(colors.white, background), greaterThanOrEqualTo(4.5));
    });

    for (final width in [320.0, 390.0, 800.0]) {
      for (final scale in [1.0, 2.0]) {
        for (final passId in ['12345678', '4294967295']) {
          testWidgets(
            '${brightness.name} text bounds retain contrast at '
            '$width/${scale}x for $passId',
            (tester) async {
              tester.view
                ..physicalSize = Size(width, 900)
                ..devicePixelRatio = 1;
              addTearDown(tester.view.reset);
              await tester.pumpWidget(
                MaterialApp(
                  theme: theme,
                  locale: const Locale('ru'),
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(scale),
                      disableAnimations: true,
                      accessibleNavigation: true,
                    ),
                    child: child!,
                  ),
                  home: Scaffold(
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.screen),
                      child: NfcPassCard(
                        passId: passId,
                        localFilePath: null,
                        isVideo: false,
                      ),
                    ),
                  ),
                ),
              );
              await tester.pump();

              expect(tester.takeException(), isNull);
              final card = tester.getRect(
                find.byKey(const ValueKey('nfc-pass-portrait')),
              );
              final header = find.byKey(
                const ValueKey('nfc-pass-header-scrim'),
              );
              final footer = find.byKey(
                const ValueKey('nfc-pass-footer-scrim'),
              );
              expect(
                tester.getRect(header).bottom,
                lessThanOrEqualTo(tester.getRect(footer).top),
              );
              await _expectScrimContrast(tester, header, card, 1);
              await _expectScrimContrast(tester, footer, card, 2);
            },
          );
        }
      }
    }
  }
}

Future<void> _expectScrimContrast(
  WidgetTester tester,
  Finder scrim,
  Rect card,
  int textCount,
) async {
  final bounds = tester.getRect(scrim);
  final color = tester.widget<ColoredBox>(scrim).color;
  final stack = tester.element(scrim).findAncestorWidgetOfExactType<Stack>()!;
  final layer = find.byWidget(stack);
  final fade = find.descendant(of: layer, matching: find.byType(DecoratedBox));
  expect(fade, findsOneWidget);
  final fadeBounds = tester.getRect(fade);
  final decoration =
      tester.widget<DecoratedBox>(fade).decoration as BoxDecoration;
  final gradient = decoration.gradient! as LinearGradient;
  final begin = gradient.begin.resolve(TextDirection.ltr);
  final end = gradient.end.resolve(TextDirection.ltr);
  expect(gradient.colors.first, color);
  expect(gradient.colors.last.a, 0);
  expect(fadeBounds.left, bounds.left);
  expect(fadeBounds.right, bounds.right);
  if (fadeBounds.top == bounds.bottom) {
    expect(begin, Alignment.topCenter);
    expect(end, Alignment.bottomCenter);
  } else {
    expect(fadeBounds.bottom, bounds.top);
    expect(begin, Alignment.bottomCenter);
    expect(end, Alignment.topCenter);
  }
  final texts = find.descendant(of: layer, matching: find.byType(Text));
  expect(texts, findsNWidgets(textCount));
  final cardTexts = find.descendant(
    of: find.byType(NfcPassCard),
    matching: find.byType(Text),
  );
  for (var index = 0; index < cardTexts.evaluate().length; index++) {
    expect(fadeBounds.overlaps(tester.getRect(cardTexts.at(index))), isFalse);
  }
  final textBounds = <Rect>[];
  for (var index = 0; index < textCount; index++) {
    final text = texts.at(index);
    expect(tester.widget<Text>(text).style!.color, Colors.white);
    final textRect = tester.getRect(text);
    _expectContains(card, textRect);
    _expectContains(bounds, textRect);
    textBounds.add(textRect.shift(-bounds.topLeft));
  }

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paintBounds = Offset.zero & bounds.size;
  canvas
    ..drawRect(paintBounds, Paint()..color = Colors.white)
    ..drawRect(
      paintBounds,
      Paint()..color = color,
    );
  final picture = recorder.endRecording();
  try {
    await tester.runAsync(() async {
      final image = await picture.toImage(
        bounds.width.ceil(),
        bounds.height.ceil(),
      );
      try {
        final data = (await image.toByteData())!;
        for (final textRect in textBounds) {
          var minimum = double.infinity;
          for (var y = textRect.top.floor(); y < textRect.bottom.ceil(); y++) {
            for (final x in [
              textRect.left.floor(),
              textRect.center.dx.floor(),
              textRect.right.ceil() - 1,
            ]) {
              final offset = (y * image.width + x) * 4;
              final background = Color.fromARGB(
                data.getUint8(offset + 3),
                data.getUint8(offset),
                data.getUint8(offset + 1),
                data.getUint8(offset + 2),
              );
              minimum = math.min(minimum, _contrast(Colors.white, background));
            }
          }
          expect(
            minimum,
            greaterThanOrEqualTo(4.5),
            reason:
                'All text bounds $textRect must meet contrast over white '
                'within scrim $bounds; minimum was $minimum.',
          );
        }
      } finally {
        image.dispose();
      }
    });
  } finally {
    picture.dispose();
  }
}

void _expectContains(Rect outer, Rect inner) {
  expect(inner.left, greaterThanOrEqualTo(outer.left));
  expect(inner.top, greaterThanOrEqualTo(outer.top));
  expect(inner.right, lessThanOrEqualTo(outer.right));
  expect(inner.bottom, lessThanOrEqualTo(outer.bottom));
}

double _contrast(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  return (math.max(firstLuminance, secondLuminance) + .05) /
      (math.min(firstLuminance, secondLuminance) + .05);
}
