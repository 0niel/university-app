import 'dart:ui' show Tristate;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_about_sheet.dart';

void main() {
  testWidgets('rating stars keep 44px targets and report selection', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      var rating = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MiniAppAboutSheet(
              app: const MiniApp(id: 'app', slug: 'demo', name: 'Демо'),
              onRate: (value) async => rating = value,
            ),
          ),
        ),
      );

      for (var star = 1; star <= 5; star++) {
        final target = find.bySemanticsLabel('$star');
        expect(target, findsOneWidget);
        expect(tester.getSize(target), const Size(44, 44));
      }

      await tester.tap(find.bySemanticsLabel('4'));
      await tester.pump();
      expect(rating, 4);
      final selected = tester.getSemantics(find.bySemanticsLabel('4'));
      expect(selected.flagsCollection.isSelected, Tristate.isTrue);
    } finally {
      semantics.dispose();
    }
  });
}
