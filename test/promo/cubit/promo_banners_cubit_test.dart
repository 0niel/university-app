import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/promo/cubit/promo_banners_cubit.dart';

class MockPromoRepository extends Mock implements PromoRepository {}

const cached = PromoBanner(
  id: 'cached',
  slug: 'cached',
  title: 'Cached',
  ctaUrl: 'https://example.com',
);
const fresh = PromoBanner(
  id: 'fresh',
  slug: 'fresh',
  title: 'Fresh',
  ctaUrl: 'https://example.com',
);

void main() {
  late MockPromoRepository repository;

  setUpAll(() {
    registerFallbackValue(PromoEvent.impression);
    registerFallbackValue(PromoPlacement.home);
  });

  setUp(() {
    repository = MockPromoRepository();
    when(
      () => repository.trackEvent(
        bannerId: any(named: 'bannerId'),
        event: any(named: 'event'),
        placement: any(named: 'placement'),
      ),
    ).thenAnswer((_) async {});
  });

  group('PromoBannersCubit', () {
    blocTest<PromoBannersCubit, PromoBannersState>(
      'emits cached banners first, then the fresh list',
      build: () => PromoBannersCubit(repository),
      setUp: () {
        when(
          () => repository.readCachedBanners(locale: 'ru'),
        ).thenAnswer((_) async => [cached]);
        when(
          () => repository.getBanners(locale: 'ru'),
        ).thenAnswer((_) async => [fresh]);
      },
      act: (cubit) => cubit.load(locale: 'ru'),
      expect: () => [
        const PromoBannersState(isLoading: true),
        const PromoBannersState(
          isLoading: true,
          loaded: true,
          banners: [cached],
        ),
        const PromoBannersState(loaded: true, banners: [fresh]),
      ],
      verify: (cubit) => expect(cubit.bySlug('fresh'), fresh),
    );

    blocTest<PromoBannersCubit, PromoBannersState>(
      'keeps cached banners when the network request fails',
      build: () => PromoBannersCubit(repository),
      setUp: () {
        when(
          () => repository.readCachedBanners(locale: 'ru'),
        ).thenAnswer((_) async => [cached]);
        when(
          () => repository.getBanners(locale: 'ru'),
        ).thenThrow(Exception('offline'));
      },
      act: (cubit) => cubit.load(locale: 'ru'),
      errors: () => [isA<Exception>()],
      verify: (cubit) {
        expect(cubit.state.banners, [cached]);
        expect(cubit.state.isLoading, isFalse);
        expect(cubit.state.loaded, isTrue);
      },
    );

    test('tracks an impression once per banner and placement', () {
      PromoBannersCubit(repository)
        ..trackImpression(fresh, PromoPlacement.home)
        ..trackImpression(fresh, PromoPlacement.home)
        ..trackImpression(fresh, PromoPlacement.schedule);

      verify(
        () => repository.trackEvent(
          bannerId: 'fresh',
          event: PromoEvent.impression,
          placement: PromoPlacement.home,
        ),
      ).called(1);
      verify(
        () => repository.trackEvent(
          bannerId: 'fresh',
          event: PromoEvent.impression,
          placement: PromoPlacement.schedule,
        ),
      ).called(1);
    });
  });
}
