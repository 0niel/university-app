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
