import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/about_section.dart';

import '../../gallery/gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);

  for (final language in ['ru', 'en']) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'repository link stays separate and works in $language/$scale',
        (
          tester,
        ) async {
          tester.view.physicalSize = const Size(320, 844);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          var aboutTaps = 0;
          var repositoryTaps = 0;
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.lightTheme,
              locale: Locale(language),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(scale),
                  disableAnimations: true,
                ),
                child: child!,
              ),
              home: Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screen),
                  child: AboutSection(
                    appName: 'Campus App',
                    version: '1.0.0',
                    onTap: () => aboutTaps++,
                    onOpenRepository: () => repositoryTaps++,
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final l10n = tester.element(find.byType(AboutSection)).l10n;
          final description = find.text(l10n.settingsAboutDescription);
          final repository = find.byKey(
            const ValueKey('about-repository-link'),
          );
          expect(description, findsOneWidget);
          expect(find.text(kGithubRepoLabel), findsOneWidget);
          expect(
            tester.getTopLeft(repository).dy,
            greaterThanOrEqualTo(tester.getBottomLeft(description).dy),
          );
          await tester.ensureVisible(repository);
          await tester.tap(repository);
          await tester.pumpAndSettle();
          expect(repositoryTaps, 1);
          expect(aboutTaps, 0);
          await tester.ensureVisible(find.text('Campus App'));
          await tester.tap(find.text('Campus App'));
          await tester.pumpAndSettle();
          expect(aboutTaps, 1);
          expect(repositoryTaps, 1);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
