import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/promo/cubit/promo_dismissals_cubit.dart';

class MockStorage extends Mock implements Storage {}

const banner = PromoBanner(
  id: 'b1',
  slug: 'yandex',
  title: 'Курьер',
  ctaUrl: 'https://example.com',
  version: 3,
  snoozeHours: 48,
);

void main() {
  final now = DateTime(2026, 9, 4, 12);

  setUp(() {
    final storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('PromoDismissalsCubit', () {
    test('shows every banner by default', () {
      expect(PromoDismissalsCubit().state.isVisible(banner, now), isTrue);
    });

    blocTest<PromoDismissalsCubit, PromoDismissalsState>(
      'snooze hides the banner until the snooze window passes',
      build: PromoDismissalsCubit.new,
      act: (cubit) => cubit.snooze(banner, now: now),
      verify: (cubit) {
        expect(cubit.state.isVisible(banner, now), isFalse);
        expect(
          cubit.state.isVisible(banner, now.add(const Duration(hours: 47))),
          isFalse,
        );
        expect(
          cubit.state.isVisible(banner, now.add(const Duration(hours: 48))),
          isTrue,
        );
      },
    );

    blocTest<PromoDismissalsCubit, PromoDismissalsState>(
      'hide keeps the banner hidden until the backend bumps its version',
      build: PromoDismissalsCubit.new,
      act: (cubit) => cubit.hide(banner),
      verify: (cubit) {
        expect(cubit.state.isVisible(banner, now), isFalse);
        expect(
          cubit.state.isVisible(banner.copyWith(version: 4), now),
          isTrue,
        );
      },
    );

    blocTest<PromoDismissalsCubit, PromoDismissalsState>(
      'reset clears snoozes and permanent hides',
      build: PromoDismissalsCubit.new,
      act: (cubit) => cubit
        ..snooze(banner, now: now)
        ..hide(banner.copyWith(id: 'b2'))
        ..reset(),
      verify: (cubit) => expect(cubit.state, const PromoDismissalsState()),
    );

    test('survives a json round-trip and ignores malformed entries', () {
      final cubit = PromoDismissalsCubit()
        ..snooze(banner, now: now)
        ..hide(banner.copyWith(id: 'b2'));
      final json = cubit.toJson(cubit.state)!;
      final restored = PromoDismissalsState.fromJson({
        ...json,
        'snoozedUntil': {...json['snoozedUntil'] as Map, 'bad': 'oops'},
        'hidden': [...json['hidden'] as List, 42],
      });

      expect(restored, cubit.state);
    });
  });
}
