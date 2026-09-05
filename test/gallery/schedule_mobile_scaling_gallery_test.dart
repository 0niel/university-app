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
  for (final width in [360.0, 430.0]) {
    testWidgets(
      'schedule scales as a whole at $width',
      (tester) async {
        tester.view
          ..physicalSize = Size(width, (width * 1280 / 581).roundToDouble())
          ..devicePixelRatio = 1
          ..padding = const FakeViewPadding(top: 24, bottom: 16);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => AppScale(child: child!),
            home: Scaffold(body: scheduleGalleryScene()),
          ),
        );
        await tester.pumpAndSettle();
        final previous = tester.getTopLeft(find.text('← нед'));
        final next = tester.getTopLeft(find.text('нед →'));
        expect(previous.dy, closeTo(next.dy, .001));
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/schedule_mobile_${width.toInt()}_dark.png',
          ),
        );
      },
      variant: const TargetPlatformVariant({TargetPlatform.android}),
    );
  }
}
