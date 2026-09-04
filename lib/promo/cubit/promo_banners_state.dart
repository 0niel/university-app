part of 'promo_banners_cubit.dart';

@freezed
abstract class PromoBannersState with _$PromoBannersState {
  const factory PromoBannersState({
    @Default(<PromoBanner>[]) List<PromoBanner> banners,
    @Default(false) bool loaded,
    @Default(false) bool isLoading,
  }) = _PromoBannersState;
}
