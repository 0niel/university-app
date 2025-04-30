part of 'full_screen_ads_bloc.dart';

enum FullScreenAdsStatus {
  initial,
  loadingInterstitialAd,
  loadingInterstitialAdFailed,
  loadingInterstitialAdSucceeded,
  showingInterstitialAd,
  showingInterstitialAdFailed,
  showingInterstitialAdSucceeded,
  loadingRewardedAd,
  loadingRewardedAdFailed,
  loadingRewardedAdSucceeded,
  showingRewardedAd,
  showingRewardedAdFailed,
  showingRewardedAdSucceeded,
}

class FullScreenAdsState extends Equatable {
  const FullScreenAdsState({required this.status, this.interstitialAd, this.rewardedAd, this.earnedReward});

  const FullScreenAdsState.initial() : this(status: FullScreenAdsStatus.initial);

  final InterstitialAd? interstitialAd;
  final RewardedAd? rewardedAd;
  final Reward? earnedReward;
  final FullScreenAdsStatus status;

  @override
  List<Object?> get props => [interstitialAd, rewardedAd, earnedReward, status];

  FullScreenAdsState copyWith({
    InterstitialAd? interstitialAd,
    RewardedAd? rewardedAd,
    Reward? earnedReward,
    FullScreenAdsStatus? status,
  }) => FullScreenAdsState(
    interstitialAd: interstitialAd ?? this.interstitialAd,
    rewardedAd: rewardedAd ?? this.rewardedAd,
    earnedReward: earnedReward ?? this.earnedReward,
    status: status ?? this.status,
  );
}

class FullScreenAdsConfig {
  const FullScreenAdsConfig({this.interstitialAdUnitId, this.rewardedAdUnitId});

  /// The unit id of an interstitial ad.
  final String? interstitialAdUnitId;

  /// The unit id of an interstitial ad.
  final String? rewardedAdUnitId;

  /// The Android test unit id of an interstitial ad.
  static const androidTestInterstitialAdUnitId = 'demo-interstitial-yandex';

  /// The Android test unit id of a rewarded ad.
  static const androidTestRewardedAdUnitId = 'demo-rewarded-yandex';

  /// The iOS test unit id of an interstitial ad.
  static const iosTestInterstitialAdUnitId = 'demo-interstitial-yandex';

  /// The iOS test unit id of a rewarded ad.
  static const iosTestRewardedAdUnitId = 'demo-rewarded-yandex';
}
