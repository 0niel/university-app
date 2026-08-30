import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';

class MockNfcPassRepository extends Mock implements NfcPassRepository {}

void main() {
  late NfcPassRepository repository;

  setUp(() {
    repository = MockNfcPassRepository();
  });

  NfcHceCubit buildCubit() => NfcHceCubit(repository: repository);

  group('NfcHceCubit', () {
    test('initial state is an unloaded NfcHceState', () {
      expect(buildCubit().state, const NfcHceState());
    });

    group('refresh', () {
      blocTest<NfcHceCubit, NfcHceState>(
        'emits available + enabled when supported and switched on',
        setUp: () {
          when(repository.isNfcAvailable).thenAnswer((_) async => true);
          when(repository.isNfcEnabled).thenAnswer((_) async => true);
        },
        build: buildCubit,
        act: (cubit) => cubit.refresh(),
        expect: () => const [
          NfcHceState(available: true, loaded: true),
        ],
      );

      blocTest<NfcHceCubit, NfcHceState>(
        'does not query the enabled state when unsupported',
        setUp: () =>
            when(repository.isNfcAvailable).thenAnswer((_) async => false),
        build: buildCubit,
        act: (cubit) => cubit.refresh(),
        expect: () => const [
          NfcHceState(enabled: false, loaded: true),
        ],
        verify: (_) => verifyNever(repository.isNfcEnabled),
      );

      blocTest<NfcHceCubit, NfcHceState>(
        'falls back to a loaded-but-empty state on failure',
        setUp: () =>
            when(repository.isNfcAvailable).thenThrow(Exception('boom')),
        build: buildCubit,
        act: (cubit) => cubit.refresh(),
        expect: () => const [NfcHceState(loaded: true)],
      );
    });

    group('setEnabled', () {
      blocTest<NfcHceCubit, NfcHceState>(
        'forwards the flag and reflects the new value',
        setUp: () => when(
          () => repository.setNfcEnabled(enabled: any(named: 'enabled')),
        ).thenAnswer((_) async {}),
        build: buildCubit,
        seed: () => const NfcHceState(available: true, loaded: true),
        act: (cubit) => cubit.setEnabled(enabled: false),
        expect: () => const [
          NfcHceState(available: true, enabled: false, loaded: true),
        ],
        verify: (_) =>
            verify(() => repository.setNfcEnabled(enabled: false)).called(1),
      );

      blocTest<NfcHceCubit, NfcHceState>(
        'is a no-op when card emulation is unavailable',
        build: buildCubit,
        act: (cubit) => cubit.setEnabled(enabled: false),
        expect: () => const <NfcHceState>[],
        verify: (_) => verifyNever(
          () => repository.setNfcEnabled(enabled: any(named: 'enabled')),
        ),
      );
    });
  });
}
