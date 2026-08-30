import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_auth_client/local_auth_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';

class MockStorage extends Mock implements Storage {}

class MockLocalAuthClient extends Mock implements LocalAuthClient {}

void main() {
  late Storage storage;
  late LocalAuthClient client;

  setUp(() {
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    client = MockLocalAuthClient();
  });

  PassSecurityCubit build() => PassSecurityCubit(localAuthClient: client);

  group('PassSecurityCubit', () {
    blocTest<PassSecurityCubit, PassSecurityState>(
      'refreshCapability reflects an available Face ID device',
      setUp: () => when(client.capability).thenAnswer(
        (_) async => const BiometricCapability(
          available: true,
          kind: BiometricKind.face,
        ),
      ),
      build: build,
      act: (cubit) => cubit.refreshCapability(),
      expect: () => [
        const PassSecurityState(available: true, kind: BiometricKind.face),
      ],
    );

    blocTest<PassSecurityCubit, PassSecurityState>(
      'refreshCapability disables the lock when biometrics vanish',
      setUp: () => when(client.capability).thenAnswer(
        (_) async => BiometricCapability.unavailable,
      ),
      build: build,
      seed: () => const PassSecurityState(enabled: true, available: true),
      act: (cubit) => cubit.refreshCapability(),
      expect: () => [const PassSecurityState()],
    );

    blocTest<PassSecurityCubit, PassSecurityState>(
      'setEnabled turns the lock on after a successful prompt',
      setUp: () => when(
        () => client.authenticate(reason: any(named: 'reason')),
      ).thenAnswer((_) async => true),
      build: build,
      seed: () => const PassSecurityState(available: true),
      act: (cubit) => cubit.setEnabled(enabled: true, reason: 'unlock'),
      expect: () => [const PassSecurityState(enabled: true, available: true)],
    );

    blocTest<PassSecurityCubit, PassSecurityState>(
      'setEnabled does nothing when the prompt is cancelled',
      setUp: () => when(
        () => client.authenticate(reason: any(named: 'reason')),
      ).thenAnswer((_) async => false),
      build: build,
      seed: () => const PassSecurityState(available: true),
      act: (cubit) => cubit.setEnabled(enabled: true, reason: 'unlock'),
      expect: () => <PassSecurityState>[],
    );

    test('authenticateForPass returns true when the lock is off', () async {
      final cubit = build();
      expect(await cubit.authenticateForPass(reason: 'unlock'), isTrue);
      verifyNever(() => client.authenticate(reason: any(named: 'reason')));
    });

    test(
      'authenticateForPass stays unlocked if biometrics disappeared',
      () async {
        when(client.capability).thenAnswer(
          (_) async => const BiometricCapability(
            available: true,
            kind: BiometricKind.face,
          ),
        );
        when(
          () => client.authenticate(reason: any(named: 'reason')),
        ).thenAnswer((_) async => true);
        final cubit = build();
        await cubit.refreshCapability();
        await cubit.setEnabled(enabled: true, reason: 'enable');

        when(
          () => client.authenticate(reason: any(named: 'reason')),
        ).thenThrow(const BiometricUnavailableFailure('gone'));
        expect(await cubit.authenticateForPass(reason: 'unlock'), isTrue);
      },
    );
  });
}
