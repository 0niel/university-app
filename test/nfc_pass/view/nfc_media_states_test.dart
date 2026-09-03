import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_media_preview.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_pass_card.dart';

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view
    ..physicalSize = const Size(320, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.darkTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(2),
          disableAnimations: true,
          accessibleNavigation: true,
        ),
        child: child!,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  const missing = 'Y:/Temp/foran/ui-test-missing-09a683db-6efb-40b7.png';

  testWidgets('missing image reports unavailable in settings preview', (
    tester,
  ) async {
    await _pump(
      tester,
      const NfcMediaPreview(filePath: missing, isVideo: false),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
    expect(
      find.text('Фон недоступен. Выберите другой файл.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('missing background retains masked pass without motion at 200%', (
    tester,
  ) async {
    await _pump(
      tester,
      const NfcPassCard(
        passId: '12345678',
        localFilePath: missing,
        isVideo: false,
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
    expect(find.text('12 •••• 78'), findsOneWidget);
    expect(find.text('12345678'), findsNothing);
    expect(find.byType(Animate), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
