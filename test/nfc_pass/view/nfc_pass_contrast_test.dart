import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_pass_card.dart';

import '../../gallery/gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);

  for (final brightness in Brightness.values) {
    for (final size in [
      const Size(320, 900),
      const Size(390, 900),
      const Size(800, 360),
    ]) {
      for (final scale in [1.0, 2.0]) {
        for (final passId in ['12345678', '4294967295']) {
          testWidgets(
            '${brightness.name} pass is readable at $size/${scale}x for $passId',
            (tester) async {
              tester.view
                ..physicalSize = size
                ..devicePixelRatio = 1;
              addTearDown(tester.view.reset);
              await tester.pumpWidget(
                MaterialApp(
                  theme: brightness == Brightness.light
                      ? AppTheme.lightTheme
                      : AppTheme.darkTheme,
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
                find.byKey(const ValueKey('nfc-pass-wallet')),
              );
              final texts = find.descendant(
                of: find.byType(NfcPassCard),
                matching: find.byType(Text),
              );
              expect(find.text(passId), findsNothing);
              for (var index = 0; index < texts.evaluate().length; index++) {
                final finder = texts.at(index);
                final bounds = tester.getRect(finder);
                expect(card.inflate(.01).contains(bounds.topLeft), isTrue);
                expect(card.inflate(.01).contains(bounds.bottomRight), isTrue);
                final text = tester.widget<Text>(finder);
                expect(text.style?.fontStyle, isNot(FontStyle.italic));
              }
            },
          );
        }
      }
    }
  }

  test('all card text remains readable over a white custom background', () {
    final background = Color.alphaBlend(
      const Color.fromRGBO(0, 0, 0, NfcPassCard.textScrimOpacity),
      Colors.white,
    );
    for (final foreground in [
      AppColors.dark.ink,
      AppColors.dark.ink.withValues(alpha: .78),
    ]) {
      expect(
        _contrast(Color.alphaBlend(foreground, background), background),
        greaterThanOrEqualTo(4.5),
      );
    }
  });
}

double _contrast(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  return (math.max(firstLuminance, secondLuminance) + .05) /
      (math.min(firstLuminance, secondLuminance) + .05);
}
