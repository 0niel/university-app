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

class _MockNfcPassCubit extends MockCubit<NfcPassState>
    implements NfcPassCubit {}

class _MockNfcHceCubit extends MockCubit<NfcHceState> implements NfcHceCubit {}

class _MockPassSecurityCubit extends MockCubit<PassSecurityState>
    implements PassSecurityCubit {}

void main() {
  testWidgets('releases priority without reading a deactivated context', (
    tester,
  ) async {
    final pass = _MockNfcPassCubit();
    final hce = _MockNfcHceCubit();
    final security = _MockPassSecurityCubit();
    when(() => pass.state).thenReturn(const NfcPassState());
    when(pass.checkBound).thenAnswer((_) async {});
    when(pass.releaseTurnstilePriority).thenAnswer((_) async {});
    when(() => hce.state).thenReturn(const NfcHceState());
    when(() => security.state).thenReturn(const PassSecurityState());

    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
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
    await tester.pump();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    verify(pass.releaseTurnstilePriority).called(1);
    expect(tester.takeException(), isNull);
  });
}
