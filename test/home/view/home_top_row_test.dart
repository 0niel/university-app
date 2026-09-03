import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_top_row.dart';

import '../../gallery/gallery_fonts.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadGalleryFonts);
  for (final width in [375.0, 384.0, 390.0]) {
    testWidgets('header retains reference row at $width logical pixels', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: HomeTopRow(
                userName: 'Студент',
                now: DateTime(2026, 9, 2, 20, 56),
                dotColor: AppColors.light.muted2,
                searchKey: GlobalKey(),
                level: 1,
              ),
            ),
          ),
        ),
        size: Size(width, 844),
      );
      final avatar = tester.getRect(find.byType(AppAvatar));
      final clock = tester.getRect(find.byType(HomeClockPill));
      expect(clock.center.dy, closeTo(avatar.center.dy, .1));
      expect(tester.getSize(find.byType(HomeTopRow)).height, 44);
      for (final button in tester.widgetList<AppHeaderCircleButton>(
        find.byType(AppHeaderCircleButton),
      )) {
        expect(tester.getSize(find.byWidget(button)), const Size(44, 44));
      }
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('header adapts without overflow at 320px and 200 percent', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: HomeTopRow(
              userName: 'Студент',
              now: DateTime(2026, 9, 2, 20, 56),
              dotColor: AppColors.light.muted2,
              searchKey: GlobalKey(),
            ),
          ),
        ),
      ),
      size: const Size(320, 844),
      textScaler: const TextScaler.linear(2),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getRect(find.byType(HomeClockPill)).top,
      greaterThan(tester.getRect(find.byType(AppAvatar)).bottom),
    );
  });
}
