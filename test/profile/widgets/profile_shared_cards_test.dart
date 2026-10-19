import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/profile/profile_widgets.dart';

import '../../gallery/gallery_fonts.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadGalleryFonts);

  for (final scale in [1.0, 2.0]) {
    testWidgets('shared profile cards keep actions and type at $scale', (
      tester,
    ) async {
      const name = 'Александр Александрович Константинопольский';
      const meta = 'ИКБО-01-25 · 2 курс · @student';
      var identityTaps = 0;
      var levelTaps = 0;
      await tester.pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileIdentityRow(
                  name: name,
                  meta: meta,
                  onTap: () => identityTaps++,
                ),
                const SizedBox(height: AppSpacing.screen),
                ProfileLevelCard(
                  xp: 1250,
                  streakDays: 3,
                  groupRank: 2,
                  onTap: () => levelTaps++,
                ),
              ],
            ),
          ),
        ),
        size: const Size(320, 844),
        textScaler: TextScaler.linear(scale),
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(ProfileIdentityRow),
          matching: find.byType(AppFeatureCard),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ProfileLevelCard),
          matching: find.byType(AppProgressCard),
        ),
        findsOneWidget,
      );
      for (final card in [
        find.byType(ProfileIdentityRow),
        find.byType(ProfileLevelCard),
      ]) {
        expect(
          find.descendant(of: card, matching: find.byType(AppGlassSurface)),
          findsOneWidget,
        );
      }
      final progress = tester.widget<AppProgressCard>(
        find.byType(AppProgressCard),
      );
      expect(progress.emblem, isA<AppIconTile>());
      expect(
        (progress.emblem! as AppIconTile).size,
        25 + AppSpacing.actionInset * 2,
      );
      final titleStyle = DefaultTextStyle.of(
        tester.element(find.text(name)),
      ).style;
      expect(titleStyle.fontFamily, AppText.sansFamily);
      expect(titleStyle.fontSize, AppText.identityTitle.fontSize);
      expect(titleStyle.fontStyle ?? FontStyle.normal, FontStyle.normal);
      expect(
        DefaultTextStyle.of(tester.element(find.text(meta))).style.fontSize,
        AppText.body.fontSize,
      );
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();
      expect(identityTaps, 1);
      final l10n = tester.element(find.byType(ProfileLevelCard)).l10n;
      final rank = find.text(l10n.profileGroupPlace(2));
      await tester.ensureVisible(rank);
      await tester.pumpAndSettle();
      expect(rank.hitTestable(), findsOneWidget);
      expect(
        DefaultTextStyle.of(tester.element(rank)).style.fontSize,
        AppText.captionStrong.fontSize,
      );
      await tester.tap(rank);
      await tester.pumpAndSettle();
      expect(levelTaps, 1);
      expect(identityTaps, 1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('read-only identity omits empty meta and the edit affordance', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: ProfileIdentityRow(name: 'Студент', meta: ''),
      ),
      size: const Size(320, 844),
    );
    await tester.pumpAndSettle();
    final card = tester.widget<AppFeatureCard>(find.byType(AppFeatureCard));
    expect(card.onTap, isNull);
    expect(card.subtitle, isNull);
    expect(card.trailing, isNull);
    expect(card.leading, isNotNull);
    expect(tester.takeException(), isNull);
  });
}
