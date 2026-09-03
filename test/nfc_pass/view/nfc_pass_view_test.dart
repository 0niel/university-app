import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/view/nfc_pass_view.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_pass_card.dart';

void main() {
  Widget buildSubject(NfcPassState state) {
    return MaterialApp(
      theme: NinjaTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: NfcPassView(
          state: state,
          onConnect: () {},
          onEnterCode: () {},
          onRetry: () {},
        ),
      ),
    );
  }

  group('NfcPassView', () {
    testWidgets(
      'shows a Ninja skeleton and no spinner on the initial load',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(const NfcPassState(status: NfcPassStatus.loading)),
        );
        await tester.pump();

        expect(find.byType(NinjaSkeleton), findsWidgets);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets(
      'shows a portrait card skeleton on action '
      'transitions',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(const NfcPassState(status: NfcPassStatus.loading)),
        );
        await tester.pump();

        await tester.pumpWidget(
          buildSubject(const NfcPassState()),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await tester.pumpWidget(
          buildSubject(const NfcPassState(status: NfcPassStatus.loading)),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(NinjaSkeleton), findsWidgets);
      },
    );

    testWidgets('loading skeleton mirrors the portrait pass card', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const NfcPassState(status: NfcPassStatus.loading)),
      );
      await tester.pump();

      final skeletons = tester
          .widgetList<NinjaSkeleton>(find.byType(NinjaSkeleton))
          .toList();
      expect(skeletons.length, 1);
      expect(skeletons.single.radius, AppRadius.card);
      final size = tester.getSize(find.byType(NinjaSkeleton));
      expect(size.width / size.height, NfcPassCard.aspectRatio);
      expect(size.width, NfcPassCard.maxWidth);
    });

    testWidgets('the unbound state offers a pill call to action', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(const NfcPassState()));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(NinjaEmptyState), findsOneWidget);
      final button = tester.widget<NinjaPillButton>(
        find.byType(NinjaPillButton),
      );
      expect(button.onPressed, isNotNull);
      expect(button.height, greaterThanOrEqualTo(44));
    });

    testWidgets('fits the connect flow on a compact screen with large text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(
        tester.platformDispatcher.clearTextScaleFactorTestValue,
      );

      await tester.pumpWidget(buildSubject(const NfcPassState()));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
