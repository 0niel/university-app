import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/promo/cubit/promo_dismissals_cubit.dart';

List<PromoBanner> visiblePromoBanners({
  required List<PromoBanner> banners,
  required PromoDismissalsState dismissals,
  required PromoPlacement placement,
  required DateTime now,
  PromoHomeSlot? homeSlot,
}) {
  final visible = [
    for (final banner in banners)
      if (banner.showsOn(placement) &&
          (homeSlot == null || banner.homeSlot == homeSlot) &&
          dismissals.isVisible(banner, now))
        banner,
  ]..sort((a, b) => b.priority.compareTo(a.priority));
  return visible;
}
