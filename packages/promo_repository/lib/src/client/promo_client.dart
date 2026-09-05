import 'package:promo_repository/src/models/promo_banner.dart';
import 'package:promo_repository/src/models/promo_dismissal.dart';
import 'package:promo_repository/src/models/promo_enums.dart';
import 'package:supabase/supabase.dart';

class PromoClient {
  const PromoClient(this._supabase);

  final SupabaseClient _supabase;

  Future<List<PromoBanner>> getBanners({
    required String organizationId,
    required String locale,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'get_promo_banners',
      params: {'p_organization_id': organizationId, 'p_locale': locale},
    );
    return parseBanners(response);
  }

  Future<void> trackEvent({
    required String bannerId,
    required PromoEvent event,
    PromoPlacement? placement,
  }) => _supabase.rpc<Object?>(
    'track_promo_banner_event',
    params: {
      'p_banner_id': bannerId,
      'p_event': event.name,
      'p_placement': placement?.name,
    },
  );

  Future<List<PromoDismissal>> getDismissals(String userId) async {
    final response = await _supabase.rpc<List<dynamic>>(
      'get_promo_banner_dismissals',
      params: {'p_expected_user_id': userId},
    );
    return [
      for (final row in response)
        PromoDismissal.fromJson((row as Map).cast<String, dynamic>()),
    ];
  }

  Future<void> saveDismissal(String userId, PromoDismissal dismissal) async {
    await _supabase.rpc<void>(
      'save_promo_banner_dismissal',
      params: {
        'p_expected_user_id': userId,
        'p_banner_id': dismissal.bannerId,
        'p_banner_version': dismissal.version,
        'p_hidden': dismissal.hidden,
        'p_snoozed_until': dismissal.snoozedUntil?.toUtc().toIso8601String(),
      },
    );
  }

  static List<PromoBanner> parseBanners(Object? response) {
    if (response is! List<Object?>) {
      throw const FormatException(
        'Promo banners RPC returned an invalid result',
      );
    }
    return [
      for (final item in response)
        if (item is Map<Object?, Object?>) PromoBanner.fromJson(item.cast()),
    ];
  }
}
