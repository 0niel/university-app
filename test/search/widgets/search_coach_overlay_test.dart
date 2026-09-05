import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/widgets/search_coach_callout.dart';
import 'package:rtu_mirea_app/search/widgets/search_coach_overlay.dart';

void main() {
  for (final width in [360.0, 430.0]) {
    testWidgets(
      'coach stays below its scaled anchor at $width',
      (tester) async {
        tester.view
          ..physicalSize = Size(width, 900) * 3
          ..devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        final anchorKey = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (_, child) => AppScale(child: child!),
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(left: 20, top: 24),
                child: Stack(
                  children: [
                    Positioned(
                      top: 120,
                      left: 40,
                      child: SizedBox(key: anchorKey, width: 50, height: 44),
                    ),
                    Positioned.fill(
                      child: SearchCoachOverlay(
                        anchorKey: anchorKey,
                        onDismiss: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        final callout = tester.getTopLeft(find.byType(SearchCoachCallout));
        final anchor = tester.getBottomRight(find.byKey(anchorKey));
        expect(callout.dy - anchor.dy, closeTo(16 * width / 390, .001));
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  }
}
