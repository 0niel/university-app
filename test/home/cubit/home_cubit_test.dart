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

    test(
      'onboarding changes preserve dismissed coaching and stable storage',
      () async {
        final cubit = HomeCubit();
        addTearDown(cubit.close);
        expect(cubit.storagePrefix, 'HomeCubit');
        cubit
          ..dismissSearchCoach()
          ..closeOnboarding();
        expect(cubit.state.settings.onboardingShown, isTrue);
        expect(cubit.state.searchCoachShown, isTrue);
        cubit.resetOnboarding();
        expect(cubit.state.settings.onboardingShown, isFalse);
        expect(cubit.state.searchCoachShown, isTrue);
      },
    );

    test(
      'a fresh instance restores completed onboarding from storage',
      () async {
        final persisted = <String, dynamic>{};
        when(() => storage.read(any())).thenAnswer(
          (invocation) => persisted[invocation.positionalArguments.first],
        );
        when(() => storage.write(any(), any<dynamic>())).thenAnswer((
          invocation,
        ) async {
          persisted[invocation.positionalArguments.first as String] =
              invocation.positionalArguments[1];
        });
        final first = HomeCubit()..closeOnboarding();
        await first.close();
        final restored = HomeCubit();
        addTearDown(restored.close);
        expect(restored.state.settings.onboardingShown, isTrue);
      },
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
