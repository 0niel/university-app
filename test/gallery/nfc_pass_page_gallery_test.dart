@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/view/nfc_pass_page.dart';

import 'gallery_fonts.dart';

class _PassCubit extends MockCubit<NfcPassState> implements NfcPassCubit {}

class _HceCubit extends MockCubit<NfcHceState> implements NfcHceCubit {}

class _SecurityCubit extends MockCubit<PassSecurityState>
    implements PassSecurityCubit {}

void main() {
  setUpAll(loadGalleryFonts);

  for (final dark in [false, true]) {
    for (final loading in [false, true]) {
      final theme = dark ? 'dark' : 'light';
      final state = loading ? 'loading' : 'bound';
      testWidgets('portrait pass page $state $theme', (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final pass = _PassCubit();
        final hce = _HceCubit();
        final security = _SecurityCubit();
        when(() => pass.state).thenReturn(
          NfcPassState(
            status: loading ? NfcPassStatus.loading : NfcPassStatus.bound,
            passId: loading ? null : 20214187,
          ),
        );
        when(pass.checkBound).thenAnswer((_) async {});
        when(pass.claimTurnstilePriority).thenAnswer((_) async {});
        when(pass.releaseTurnstilePriority).thenAnswer((_) async {});
        when(() => hce.state).thenReturn(const NfcHceState());
        when(() => security.state).thenReturn(const PassSecurityState());
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            ),
            home: MultiBlocProvider(
              providers: [
                BlocProvider<NfcPassCubit>.value(value: pass),
                BlocProvider<NfcHceCubit>.value(value: hce),
                BlocProvider<PassSecurityCubit>.value(value: security),
              ],
              child: const NfcPassPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/nfc_pass_portrait_${state}_$theme.png'),
        );
      });
    }
  }
}
