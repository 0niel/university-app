part of 'full_screen_ads_bloc.dart';

@freezed
abstract class FullScreenAdsState with _$FullScreenAdsState {
  const factory FullScreenAdsState({
    InterstitialAd? interstitialAd,
    RewardedAd? rewardedAd,
    Reward? earnedReward,
    @Default(FullScreenAdsStatus.initial) FullScreenAdsStatus status,
  }) = _FullScreenAdsState;

  const FullScreenAdsState._();
}

class FullScreenAdsConfig {
  const FullScreenAdsConfig({this.interstitialAdUnitId, this.rewardedAdUnitId});

  final String? interstitialAdUnitId;

  final String? rewardedAdUnitId;

  static const testInterstitialAdUnitId = 'demo-interstitial-yandex';

  static const testRewardedAdUnitId = 'demo-rewarded-yandex';
}
