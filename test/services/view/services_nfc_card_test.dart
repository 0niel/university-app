import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_nfc_card.dart';

import '../../helpers/pump_app.dart';

class _Pass extends MockCubit<NfcPassState> implements NfcPassCubit {}

class _Hce extends MockCubit<NfcHceState> implements NfcHceCubit {}

class _Security extends MockCubit<PassSecurityState>
    implements PassSecurityCubit {}

void main() {
  late _Pass pass;
  late _Hce hce;
  late _Security security;

  setUp(() {
    pass = _Pass();
    hce = _Hce();
    security = _Security();
    when(() => pass.state).thenReturn(
      const NfcPassState(status: NfcPassStatus.bound, passId: 12345),
    );
    when(
      () => hce.state,
    ).thenReturn(const NfcHceState(available: true, loaded: true));
    when(pass.claimTurnstilePriority).thenAnswer((_) async {});
    when(pass.releaseTurnstilePriority).thenAnswer((_) async {});
    when(
      () => security.authenticateForPass(reason: any(named: 'reason')),
    ).thenAnswer((_) async => true);
  });

  Widget subject() => MultiBlocProvider(
    providers: [
      BlocProvider<NfcPassCubit>.value(value: pass),
      BlocProvider<NfcHceCubit>.value(value: hce),
      BlocProvider<PassSecurityCubit>.value(value: security),
    ],
    child: const Center(child: ServicesNfcCard()),
  );

  testWidgets('denied biometrics never claim turnstile priority', (
    tester,
  ) async {
    when(
      () => security.authenticateForPass(reason: any(named: 'reason')),
    ).thenAnswer((_) async => false);
    await tester.pumpApp(subject());
    await tester.tap(find.byKey(const ValueKey('services-nfc-card')));
    await tester.pump();
    verify(
      () => security.authenticateForPass(reason: any(named: 'reason')),
    ).called(1);
    verifyNever(pass.claimTurnstilePriority);
  });

  testWidgets('successful unlock activates for exactly thirty seconds', (
    tester,
  ) async {
    await tester.pumpApp(subject());
    await tester.tap(find.byKey(const ValueKey('services-nfc-card')));
    await tester.pump();
    verify(pass.claimTurnstilePriority).called(1);
    await tester.pump(const Duration(seconds: 29));
    verifyNever(pass.releaseTurnstilePriority);
    await tester.pump(const Duration(seconds: 1));
    verify(pass.releaseTurnstilePriority).called(1);
  });

  testWidgets('disposal releases active priority without looking up context', (
    tester,
  ) async {
    await tester.pumpApp(subject());
    await tester.tap(find.byKey(const ValueKey('services-nfc-card')));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    verify(pass.releaseTurnstilePriority).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a pending unlock cannot activate after disposal', (
    tester,
  ) async {
    final unlock = Completer<bool>();
    when(
      () => security.authenticateForPass(reason: any(named: 'reason')),
    ).thenAnswer((_) => unlock.future);
    await tester.pumpApp(subject());
    await tester.tap(find.byKey(const ValueKey('services-nfc-card')));
    await tester.pumpWidget(const SizedBox.shrink());
    unlock.complete(true);
    await tester.pump();
    verifyNever(pass.claimTurnstilePriority);
    expect(tester.takeException(), isNull);
  });

  testWidgets('backgrounding cancels active priority', (tester) async {
    await tester.pumpApp(subject());
    await tester.tap(find.byKey(const ValueKey('services-nfc-card')));
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    verify(pass.releaseTurnstilePriority).called(1);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  });
}
