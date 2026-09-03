@Tags(['gallery'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';

import '../schedule/view/schedule_page/schedule_export_fixture.dart';
import 'gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);
  final l10n = AppLocalizationsRu();
  for (final dark in [false, true]) {
    for (final compact in [false, true]) {
      final theme = dark ? 'dark' : 'light';
      final layout = compact ? 'compact' : 'regular';
      testWidgets('export calendar $layout $theme', (tester) async {
        await pumpExportFixture(
          tester,
          dark: dark,
          size: compact ? const Size(320, 568) : const Size(390, 844),
          textScale: compact ? 2 : 1,
        );
        await tester.ensureVisible(find.text(l10n.exportSystemCalendar));
        await tester.tap(find.text(l10n.exportSystemCalendar));
        await tester.pumpAndSettle();
        final scroll = tester.widget<SingleChildScrollView>(
          find.byKey(const ValueKey('schedule-export-scroll')),
        );
        for (final bottom in [false, true]) {
          scroll.controller!.jumpTo(
            bottom ? scroll.controller!.position.maxScrollExtent : 0,
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile(
              'goldens/schedule_export_${layout}_${theme}_${bottom ? 'bottom' : 'top'}.png',
            ),
          );
        }
      });
    }
  }
}
