import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:promo_repository/promo_repository.dart';

part 'promo_banners_cubit.freezed.dart';
part 'promo_banners_state.dart';

class PromoBannersCubit extends Cubit<PromoBannersState> {
  PromoBannersCubit(this._repository) : super(const PromoBannersState());

  final PromoRepository _repository;
  final _impressions = <String>{};
  var _requestId = 0;

  Future<void> load({required String locale}) async {
    final requestId = ++_requestId;
    if (!state.loaded) {
      emit(state.copyWith(isLoading: true));
      final cached = await _repository.readCachedBanners(locale: locale);
      if (isClosed || requestId != _requestId) return;
      if (cached != null) {
        emit(state.copyWith(banners: cached, loaded: true));
      }
    }
    try {
      final banners = await _repository.getBanners(locale: locale);
      if (isClosed || requestId != _requestId) return;
      emit(state.copyWith(banners: banners, loaded: true, isLoading: false));
    } on Object catch (error, stackTrace) {
      if (isClosed || requestId != _requestId) return;
      addError(error, stackTrace);
      emit(state.copyWith(isLoading: false));
    }
  }

  PromoBanner? bySlug(String slug) =>
      state.banners.where((banner) => banner.slug == slug).firstOrNull;

  void trackImpression(PromoBanner banner, PromoPlacement placement) {
    if (!_impressions.add('${banner.id}:${placement.name}')) return;
    _track(banner, PromoEvent.impression, placement);
  }

  void trackEvent(
    PromoBanner banner,
    PromoEvent event, {
    PromoPlacement? placement,
  }) => _track(banner, event, placement);

  void _track(PromoBanner banner, PromoEvent event, PromoPlacement? placement) {
    _repository
        .trackEvent(bannerId: banner.id, event: event, placement: placement)
        .ignore();
  }
}
