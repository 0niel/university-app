@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import 'gallery_fonts.dart';
import 'schedule_gallery.dart';

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    testWidgets('schedule safe inset ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1
        ..padding = const FakeViewPadding(top: 43, bottom: 16);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: scheduleGalleryScene()),
        ),
      );
      await tester.pumpAndSettle();
      final theme = dark ? 'dark' : 'light';
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/schedule_safe_inset_$theme.png'),
      );
      await tester.drag(find.byType(NestedScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/schedule_safe_pinned_$theme.png'),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
