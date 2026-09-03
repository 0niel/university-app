import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';

class MockNfcPassRepository extends Mock implements NfcPassRepository {}

class MockImagePicker extends Mock implements ImagePicker {}

class MockStorage extends Mock implements Storage {}

void main() {
  late NfcPassRepository repository;
  late ImagePicker imagePicker;
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;

    repository = MockNfcPassRepository();
    imagePicker = MockImagePicker();
  });

  NfcPassCubit buildCubit() =>
      NfcPassCubit(repository: repository, imagePicker: imagePicker);

  group('NfcPassCubit', () {
    test('initial state is NfcPassState()', () {
      expect(buildCubit().state, const NfcPassState());
    });

    group('checkBound', () {
      blocTest<NfcPassCubit, NfcPassState>(
        'emits [loading, bound] when a pass is bound',
        setUp: () {
          when(repository.isPassBound).thenAnswer((_) async => true);
          when(repository.getPassId).thenAnswer((_) async => 12345);
        },
        build: buildCubit,
        act: (cubit) => cubit.checkBound(),
        expect: () => const [
          NfcPassState(status: NfcPassStatus.loading),
          NfcPassState(status: NfcPassStatus.bound, passId: 12345),
        ],
      );

      blocTest<NfcPassCubit, NfcPassState>(
        'emits [loading, initial] when no pass is bound',
        setUp: () =>
            when(repository.isPassBound).thenAnswer((_) async => false),
        build: buildCubit,
        act: (cubit) => cubit.checkBound(),
        expect: () => const [
          NfcPassState(status: NfcPassStatus.loading),
          NfcPassState(),
        ],
      );

      blocTest<NfcPassCubit, NfcPassState>(
        'emits [loading, error] when the repository throws',
        setUp: () => when(repository.isPassBound).thenThrow(Exception('boom')),
        build: buildCubit,
        act: (cubit) => cubit.checkBound(),
        expect: () => const [
          NfcPassState(status: NfcPassStatus.loading),
          NfcPassState(
            status: NfcPassStatus.error,
            errorMessage: 'Exception: boom',
          ),
        ],
      );
    });

    group('bindPass', () {
      blocTest<NfcPassCubit, NfcPassState>(
        'emits [loading, codeSent] when binding starts successfully',
        setUp: () => when(repository.bindPass).thenAnswer((_) async {}),
        build: buildCubit,
        act: (cubit) => cubit.bindPass(),
        expect: () => const [
          NfcPassState(status: NfcPassStatus.loading),
          NfcPassState(status: NfcPassStatus.codeSent),
        ],
      );

      blocTest<NfcPassCubit, NfcPassState>(
        'emits [loading, error] when binding throws',
        setUp: () => when(repository.bindPass).thenThrow(Exception('boom')),
        build: buildCubit,
        act: (cubit) => cubit.bindPass(),
        expect: () => const [
          NfcPassState(status: NfcPassStatus.loading),
          NfcPassState(
            status: NfcPassStatus.error,
            errorMessage: 'Exception: boom',
          ),
        ],
      );
    });

    group('confirmBinding', () {
      blocTest<NfcPassCubit, NfcPassState>(
        'emits [loading, bound] with the returned passId on success',
        setUp: () => when(
          () => repository.confirmBinding(
            sixDigitCode: any(named: 'sixDigitCode'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenAnswer((_) async => 777),
        build: buildCubit,
        act: (cubit) =>
            cubit.confirmBinding(sixDigitCode: '123456', deviceName: 'Pixel'),
        expect: () => const [
          NfcPassState(status: NfcPassStatus.loading),
          NfcPassState(status: NfcPassStatus.bound, passId: 777),
        ],
      );

      blocTest<NfcPassCubit, NfcPassState>(
        'emits [loading, error] when confirmation throws',
        setUp: () => when(
          () => repository.confirmBinding(
            sixDigitCode: any(named: 'sixDigitCode'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenThrow(Exception('boom')),
        build: buildCubit,
        act: (cubit) =>
            cubit.confirmBinding(sixDigitCode: '123456', deviceName: 'Pixel'),
        expect: () => const [
          NfcPassState(status: NfcPassStatus.loading),
          NfcPassState(
            status: NfcPassStatus.error,
            errorMessage: 'Exception: boom',
          ),
        ],
      );
    });

    group('unbindPass', () {
      blocTest<NfcPassCubit, NfcPassState>(
        'emits [loading, initial] when unbinding succeeds',
        setUp: () => when(repository.unbindPass).thenAnswer((_) async {}),
        build: buildCubit,
        seed: () => const NfcPassState(
          status: NfcPassStatus.bound,
          passId: 12345,
        ),
        act: (cubit) => cubit.unbindPass(),
        expect: () => const [
          NfcPassState(status: NfcPassStatus.loading, passId: 12345),
          NfcPassState(),
        ],
      );

      blocTest<NfcPassCubit, NfcPassState>(
        'emits [loading, error] when unbinding throws',
        setUp: () => when(repository.unbindPass).thenThrow(Exception('boom')),
        build: buildCubit,
        seed: () => const NfcPassState(status: NfcPassStatus.bound),
        act: (cubit) => cubit.unbindPass(),
        expect: () => const [
          NfcPassState(status: NfcPassStatus.loading),
          NfcPassState(
            status: NfcPassStatus.error,
            errorMessage: 'Exception: boom',
          ),
        ],
      );
    });

    group('media', () {
      blocTest<NfcPassCubit, NfcPassState>(
        'pickFile stores the selected path',
        setUp: () => when(
          imagePicker.pickMedia,
        ).thenAnswer((_) async => XFile('background.png')),
        build: buildCubit,
        act: (cubit) => cubit.pickFile(),
        expect: () => const [
          NfcPassState(localFilePath: 'background.png'),
        ],
      );

      blocTest<NfcPassCubit, NfcPassState>(
        'pickFile emits nothing when no file is selected',
        setUp: () => when(imagePicker.pickMedia).thenAnswer((_) async => null),
        build: buildCubit,
        act: (cubit) => cubit.pickFile(),
        expect: () => const <NfcPassState>[],
      );

      blocTest<NfcPassCubit, NfcPassState>(
        'removeFile clears the selected path',
        build: buildCubit,
        seed: () => const NfcPassState(localFilePath: 'background.png'),
        act: (cubit) => cubit.removeFile(),
        expect: () => const [NfcPassState()],
      );
    });

    group('isVideo', () {
      test('is true for known video extensions', () {
        expect(
          const NfcPassState(localFilePath: 'clip.mp4').isVideo,
          isTrue,
        );
        expect(
          const NfcPassState(localFilePath: 'clip.webm').isVideo,
          isTrue,
        );
      });

      test('is false for images and null', () {
        expect(const NfcPassState(localFilePath: 'pic.png').isVideo, isFalse);
        expect(const NfcPassState().isVideo, isFalse);
      });
    });

    group('hydration', () {
      test('persists only the selected background media', () {
        final cubit = buildCubit();
        addTearDown(cubit.close);
        const state = NfcPassState(
          status: NfcPassStatus.bound,
          passId: 42,
          errorMessage: 'Previous binding error',
          localFilePath: 'clip.mp4',
        );
        expect(cubit.toJson(state), {'localFilePath': 'clip.mp4'});
        expect(
          cubit.fromJson(cubit.toJson(state)),
          const NfcPassState(localFilePath: 'clip.mp4'),
        );
      });

      test('ignores legacy cached binding and errors', () {
        final cubit = buildCubit();
        addTearDown(cubit.close);
        expect(
          cubit.fromJson({
            'status': NfcPassStatus.bound.index,
            'passId': 42,
            'errorMessage': 'Previous binding error',
            'localFilePath': 'background.png',
          }),
          const NfcPassState(localFilePath: 'background.png'),
        );
        expect(cubit.fromJson({}), const NfcPassState());
      });

      test('reloads the real binding from the secure repository', () async {
        when(() => storage.read('NfcPassCubit')).thenReturn({
          'status': NfcPassStatus.bound.index,
          'passId': 42,
          'errorMessage': 'Previous binding error',
          'localFilePath': 'clip.mp4',
        });
        when(repository.isPassBound).thenAnswer((_) async => true);
        when(repository.getPassId).thenAnswer((_) async => 12345);
        final cubit = buildCubit();
        addTearDown(cubit.close);
        expect(cubit.state, const NfcPassState(localFilePath: 'clip.mp4'));

        await cubit.checkBound();

        expect(
          cubit.state,
          const NfcPassState(
            status: NfcPassStatus.bound,
            passId: 12345,
            localFilePath: 'clip.mp4',
          ),
        );
        verify(repository.isPassBound).called(1);
        verify(repository.getPassId).called(1);
      });
    });
  });
}
