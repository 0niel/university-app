import 'dart:convert';

import 'package:promo_repository/src/client/promo_client.dart';
import 'package:promo_repository/src/models/promo_banner.dart';
import 'package:promo_repository/src/models/promo_enums.dart';
import 'package:storage/storage.dart';
import 'package:supabase/supabase.dart' show SupabaseClient;

class PromoRepository {
  factory PromoRepository({
    required SupabaseClient supabase,
    required String organizationId,
    Storage? cache,
  }) => PromoRepository._(PromoClient(supabase), organizationId, cache);

  const PromoRepository._(this._client, this._organizationId, this._cache);

  final PromoClient _client;
  final String _organizationId;
  final Storage? _cache;

  String _cacheKey(String locale) => 'promo_banners.$_organizationId.$locale';

  Future<List<PromoBanner>> getBanners({required String locale}) async {
    final banners = await _client.getBanners(
      organizationId: _organizationId,
      locale: locale,
    );
    final cache = _cache;
    if (cache != null) {
      try {
        await cache.write(
          key: _cacheKey(locale),
          value: jsonEncode([for (final banner in banners) banner.toJson()]),
        );
      } on StorageException {
        return banners;
      }
    }
    return banners;
  }

  Future<List<PromoBanner>?> readCachedBanners({required String locale}) async {
    final cache = _cache;
    if (cache == null) return null;
    try {
      final raw = await cache.read(key: _cacheKey(locale));
      if (raw == null) return null;
      return PromoClient.parseBanners(jsonDecode(raw));
    } on Object {
      return null;
    }
  }

  Future<void> trackEvent({
    required String bannerId,
    required PromoEvent event,
    PromoPlacement? placement,
  }) async {
    try {
      await _client.trackEvent(
        bannerId: bannerId,
        event: event,
        placement: placement,
      );
    } on Object {
      return;
    }
  }
}
