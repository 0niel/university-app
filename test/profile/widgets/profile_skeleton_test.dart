import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/profile/profile_widgets.dart';

import '../../gallery/gallery_fonts.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadGalleryFonts);

  for (final width in [320.0, 390.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('profile skeleton follows real cards at $width / $scale', (
        tester,
      ) async {
        Widget frame(Widget child) => MediaQuery(
          data: MediaQueryData(
            size: Size(width, 844),
            textScaler: TextScaler.linear(scale),
            disableAnimations: true,
          ),
          child: Scaffold(
            body: AppAmbientBackground(
              child: SingleChildScrollView(child: child),
            ),
          ),
        );
        await tester.pumpApp(
          frame(const ProfileSkeleton()),
          size: Size(width, 844),
          textScaler: TextScaler.linear(scale),
        );
        await tester.pump();
        expect(find.byType(AppFeatureCard), findsOneWidget);
        expect(find.byType(AppProgressCard), findsOneWidget);
        expect(find.byType(AppSkeletonText), findsWidgets);
        final identityHeight = tester
            .getSize(
              find.byKey(const ValueKey('profile-identity-skeleton')),
            )
            .height;
        final levelHeight = tester
            .getSize(
              find.byKey(const ValueKey('profile-level-skeleton')),
            )
            .height;
        expect(tester.takeException(), isNull);
        expect(
          find.byKey(const ValueKey('profile-activity-skeleton')),
          findsOneWidget,
        );
        final l10n = tester.element(find.byType(ProfileSkeleton)).l10n;
        await tester.pumpApp(
          frame(
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: Column(
                children: [
                  ProfileIdentityRow(
                    name: l10n.profileStudentFallback,
                    meta: '@student',
                    onTap: () {},
                  ),
                  ProfileLevelCard(xp: 0, streakDays: 0, onTap: () {}),
                ],
              ),
            ),
          ),
          size: Size(width, 844),
          textScaler: TextScaler.linear(scale),
        );
        await tester.pump();
        expect(
          identityHeight,
          closeTo(tester.getSize(find.byType(ProfileIdentityRow)).height, 1),
        );
        expect(
          levelHeight,
          closeTo(tester.getSize(find.byType(ProfileLevelCard)).height, 1),
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}
