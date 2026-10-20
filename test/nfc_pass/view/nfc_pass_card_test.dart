import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/view/nfc_pass_view.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_pass_card.dart';

import '../../gallery/gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);

  for (final width in [320.0, 390.0, 800.0]) {
    testWidgets(
      'pass uses a compact wallet without management controls at $width',
      (
        tester,
      ) async {
        await _pump(tester, width: width);

        final size = tester.getSize(
          find.byKey(const ValueKey('nfc-pass-wallet')),
        );
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('nfc-pass-wallet'))).dy,
        AppSpacing.screen,
      );
        expect(size.width / size.height, closeTo(NfcPassCard.aspectRatio, .01));
        expect(
          size.width,
          (width - AppSpacing.screen * 2).clamp(0, NfcPassCard.maxWidth),
        );
        expect(find.text('NFC-пропуск'), findsOneWidget);
        expect(find.text('12 •••• 78'), findsOneWidget);
        expect(find.text('Приложите телефон к турникету'), findsOneWidget);
        expect(find.text('Устройство'), findsNothing);
        expect(find.text('Отвязать устройство'), findsNothing);
        expect(find.byType(NinjaButton), findsNothing);
        expect(find.byType(AppGlassSurface), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'disabled emulation never shows active status or tap instruction',
    (
      tester,
    ) async {
      await _pump(tester, width: 320, emulationOff: true);
      expect(find.text('Выключено'), findsOneWidget);
      expect(find.text('Активен'), findsNothing);
      expect(find.text('Приложите телефон к турникету'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _pump(
  WidgetTester tester, {
  required double width,
  bool emulationOff = false,
}) async {
  tester.view
    ..physicalSize = Size(width, 900)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.darkTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: NfcPassView(
          state: const NfcPassState(
            status: NfcPassStatus.bound,
            passId: 12345678,
          ),
          turnstileEmulationOff: emulationOff,
          onConnect: () {},
          onEnterCode: () {},
          onRetry: () {},
        ),
      ),
    ),
  );
  await tester.pump();
}
