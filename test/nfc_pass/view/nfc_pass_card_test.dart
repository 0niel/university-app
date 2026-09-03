import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/view/nfc_pass_view.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_pass_card.dart';

void main() {
  for (final width in [320.0, 390.0, 800.0]) {
    testWidgets('pass stays portrait with no management controls at $width', (
      tester,
    ) async {
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
              onConnect: () {},
              onEnterCode: () {},
              onRetry: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      final size = tester.getSize(
        find.byKey(const ValueKey('nfc-pass-portrait')),
      );
      expect(size.width / size.height, NfcPassCard.aspectRatio);
      expect(
        size.width,
        (width - AppSpacing.screen * 2).clamp(0, NfcPassCard.maxWidth),
      );
      expect(find.text('NFC PASS'), findsOneWidget);
      expect(find.text('12 •••• 78'), findsOneWidget);
      expect(find.text('Приложите телефон к турникету'), findsOneWidget);
      expect(find.text('Устройство'), findsNothing);
      expect(find.text('Отвязать устройство'), findsNothing);
      expect(find.byType(NinjaButton), findsNothing);
      expect(find.byType(AppCard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
