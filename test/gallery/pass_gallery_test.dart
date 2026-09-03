@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/view/nfc_pass_view.dart';

import 'gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);

  Future<void> shoot(
    WidgetTester tester,
    String name,
    NfcPassState state,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            backgroundColor: context.ninja.canvas,
            body: NfcPassView(
              state: state,
              onConnect: () {},
              onEnterCode: () {},
              onRetry: () {},
            ),
          ),
        ),
      ),
    );
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  testWidgets('6c · pass (bound)', (tester) async {
    await shoot(
      tester,
      'pass_6c_bound',
      const NfcPassState(status: NfcPassStatus.bound, passId: 20214187),
    );
  });

  testWidgets('6c · pass (not bound)', (tester) async {
    await shoot(tester, 'pass_6c_initial', const NfcPassState());
  });
}
