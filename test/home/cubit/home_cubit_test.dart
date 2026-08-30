import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/models/app_settings.dart';

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

  group('HomeCubit', () {
    test('initial state is HomeState()', () {
      expect(HomeCubit().state, equals(const HomeState()));
    });

    blocTest<HomeCubit, HomeState>(
      'closeOnboarding marks the onboardingShown flag',
      build: HomeCubit.new,
      act: (cubit) => cubit.closeOnboarding(),
      expect: () => const [
        HomeState(
          settings: AppSettings(onboardingShown: true),
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'resetOnboarding clears the onboardingShown flag',
      build: HomeCubit.new,
      seed: () => const HomeState(
        settings: AppSettings(onboardingShown: true),
      ),
      act: (cubit) => cubit.resetOnboarding(),
      expect: () => const [
        HomeState(),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'dismissSearchCoach sets the searchCoachShown flag',
      build: HomeCubit.new,
      act: (cubit) => cubit.dismissSearchCoach(),
      expect: () => const [HomeState(searchCoachShown: true)],
    );

    test('toJson/fromJson round-trips settings and the search coach flag', () {
      final cubit = HomeCubit();
      const state = HomeState(
        settings: AppSettings(onboardingShown: true, theme: 'dark'),
        searchCoachShown: true,
      );
      final json = cubit.toJson(state);
      expect(json, isNotNull);
      final restored = cubit.fromJson(json);
      expect(restored.settings, equals(state.settings));
      expect(restored.searchCoachShown, isTrue);
    });
  });
}
