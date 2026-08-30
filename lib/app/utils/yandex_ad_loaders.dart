import 'dart:developer';

import 'package:yandex_mobileads/mobile_ads.dart';

Future<void> yandexInterstitialAdLoader({
  required AdRequest adRequest,
  required void Function(InterstitialAd ad) onAdLoaded,
  required void Function(Object error) onAdFailedToLoad,
}) async {
  final loader = InterstitialAdLoader();
  try {
    final ad = await loader.loadAd(adRequest: adRequest);
    onAdLoaded(ad);
  } on Exception catch (error, st) {
    log(
      'Yandex interstitial ad failed to load',
      error: error,
      stackTrace: st,
      name: 'yandexInterstitialAdLoader',
    );
    onAdFailedToLoad(error);
  } finally {
    loader.destroy();
  }
}

Future<void> yandexRewardedAdLoader({
  required AdRequest adRequest,
  required void Function(RewardedAd ad) onAdLoaded,
  required void Function(Object error) onAdFailedToLoad,
}) async {
  final loader = RewardedAdLoader();
  try {
    final ad = await loader.loadAd(adRequest: adRequest);
    onAdLoaded(ad);
  } on Exception catch (error, st) {
    log(
      'Yandex rewarded ad failed to load',
      error: error,
      stackTrace: st,
      name: 'yandexRewardedAdLoader',
    );
    onAdFailedToLoad(error);
  } finally {
    loader.destroy();
  }
}
