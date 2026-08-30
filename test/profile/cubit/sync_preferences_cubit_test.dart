import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/profile/cubit/sync_preferences_cubit.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('SyncPreferencesCubit', () {
    test('defaults to always', () {
      expect(SyncPreferencesCubit().state, SyncPolicy.always);
    });

    blocTest<SyncPreferencesCubit, SyncPolicy>(
      'setPolicy emits the chosen policy',
      build: SyncPreferencesCubit.new,
      act: (cubit) => cubit.setPolicy(SyncPolicy.wifiOnly),
      expect: () => [SyncPolicy.wifiOnly],
    );

    test('toJson/fromJson round-trips the policy', () {
      final cubit = SyncPreferencesCubit()..setPolicy(SyncPolicy.manualOnly);
      final json = cubit.toJson(cubit.state);
      expect(json, isNotNull);
      expect(cubit.fromJson(json), SyncPolicy.manualOnly);
    });

    test('fromJson falls back to always on an unknown value', () {
      expect(
        SyncPreferencesCubit().fromJson({'policy': 'x'}),
        SyncPolicy.always,
      );
    });
  });
}
