import 'dart:async';

import 'package:ads_ui/ads_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:platform/platform.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

part 'full_screen_ads_event.dart';
part 'full_screen_ads_state.dart';

typedef YandexInterstitialAdLoader = Future<void> Function({
  required String adUnitId,
  required AdRequestConfiguration adRequestConfiguration,
  required void Function(InterstitialAd ad) onAdLoaded,
  required void Function(Object error) onAdFailedToLoad,
});

typedef YandexRewardedAdLoader = Future<void> Function({
  required String adUnitId,
  required AdRequestConfiguration adRequestConfiguration,
  required void Function(RewardedAd ad) onAdLoaded,
  required void Function(Object error) onAdFailedToLoad,
});

class FullScreenAdsBloc extends Bloc<FullScreenAdsEvent, FullScreenAdsState> {
  FullScreenAdsBloc({
    required AdsRetryPolicy adsRetryPolicy,
    required YandexInterstitialAdLoader interstitialAdLoader,
    required YandexRewardedAdLoader rewardedAdLoader,
    required LocalPlatform localPlatform,
    FullScreenAdsConfig? fullScreenAdsConfig,
  })  : _adsRetryPolicy = adsRetryPolicy,
        _interstitialAdLoader = interstitialAdLoader,
        _rewardedAdLoader = rewardedAdLoader,
        _localPlatform = localPlatform,
        _fullScreenAdsConfig = fullScreenAdsConfig ?? const FullScreenAdsConfig(),
        super(const FullScreenAdsState.initial()) {
    on<LoadInterstitialAdRequested>(_onLoadInterstitialAdRequested);
    on<LoadRewardedAdRequested>(_onLoadRewardedAdRequested);
    on<ShowInterstitialAdRequested>(_onShowInterstitialAdRequested);
    on<ShowRewardedAdRequested>(_onShowRewardedAdRequested);
    on<EarnedReward>(_onEarnedReward);
  }

  final AdsRetryPolicy _adsRetryPolicy;
  final FullScreenAdsConfig _fullScreenAdsConfig;
  final YandexInterstitialAdLoader _interstitialAdLoader;
  final YandexRewardedAdLoader _rewardedAdLoader;
  final LocalPlatform _localPlatform;

  Future<void> _onLoadInterstitialAdRequested(
    LoadInterstitialAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    try {
      final adCompleter = Completer<InterstitialAd>();

      emit(state.copyWith(status: FullScreenAdsStatus.loadingInterstitialAd));

      final adUnitId = _fullScreenAdsConfig.interstitialAdUnitId ??
          (_localPlatform.isAndroid
              ? FullScreenAdsConfig.androidTestInterstitialAdUnitId
              : FullScreenAdsConfig.iosTestInterstitialAdUnitId);

      await _interstitialAdLoader(
        adUnitId: adUnitId,
        adRequestConfiguration: AdRequestConfiguration(adUnitId: adUnitId),
        onAdLoaded: (InterstitialAd ad) => adCompleter.complete(ad),
        onAdFailedToLoad: (error) => adCompleter.completeError(error),
      );

      final loadedAd = await adCompleter.future;

      emit(
        state.copyWith(
          interstitialAd: loadedAd,
          status: FullScreenAdsStatus.loadingInterstitialAdSucceeded,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: FullScreenAdsStatus.loadingInterstitialAdFailed,
        ),
      );

      addError(error, stackTrace);

      if (event.retry < _adsRetryPolicy.maxRetryCount) {
        final nextRetry = event.retry + 1;
        await Future.delayed(_adsRetryPolicy.getIntervalForRetry(nextRetry));
        add(LoadInterstitialAdRequested(retry: nextRetry));
      }
    }
  }

  Future<void> _onLoadRewardedAdRequested(
    LoadRewardedAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    try {
      final adCompleter = Completer<RewardedAd>();

      emit(state.copyWith(status: FullScreenAdsStatus.loadingRewardedAd));

      final adUnitId = _fullScreenAdsConfig.rewardedAdUnitId ??
          (_localPlatform.isAndroid
              ? FullScreenAdsConfig.androidTestRewardedAdUnitId
              : FullScreenAdsConfig.iosTestRewardedAdUnitId);

      await _rewardedAdLoader(
        adUnitId: adUnitId,
        adRequestConfiguration: AdRequestConfiguration(adUnitId: adUnitId),
        onAdLoaded: (RewardedAd ad) => adCompleter.complete(ad),
        onAdFailedToLoad: (error) => adCompleter.completeError(error),
      );

      final loadedAd = await adCompleter.future;

      emit(
        state.copyWith(
          rewardedAd: loadedAd,
          status: FullScreenAdsStatus.loadingRewardedAdSucceeded,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: FullScreenAdsStatus.loadingRewardedAdFailed,
        ),
      );

      addError(error, stackTrace);

      if (event.retry < _adsRetryPolicy.maxRetryCount) {
        final nextRetry = event.retry + 1;
        await Future.delayed(_adsRetryPolicy.getIntervalForRetry(nextRetry));
        add(LoadRewardedAdRequested(retry: nextRetry));
      }
    }
  }

  Future<void> _onShowInterstitialAdRequested(
    ShowInterstitialAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FullScreenAdsStatus.showingInterstitialAd));

      state.interstitialAd?.setAdEventListener(
        eventListener: InterstitialAdEventListener(
          onAdDismissed: () {
            state.interstitialAd?.destroy();
          },
          onAdFailedToShow: (error) {
            state.interstitialAd?.destroy();
            addError(error);
          },
        ),
      );

      await state.interstitialAd?.show();
      await state.interstitialAd?.waitForDismiss();

      emit(
        state.copyWith(
          status: FullScreenAdsStatus.showingInterstitialAdSucceeded,
        ),
      );

      add(const LoadInterstitialAdRequested());
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: FullScreenAdsStatus.showingInterstitialAdFailed,
        ),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _onShowRewardedAdRequested(
    ShowRewardedAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FullScreenAdsStatus.showingRewardedAd));

      state.rewardedAd?.setAdEventListener(
        eventListener: RewardedAdEventListener(
          onAdDismissed: () {
            state.rewardedAd?.destroy();
          },
          onAdFailedToShow: (error) {
            state.rewardedAd?.destroy();
            addError(error);
          },
          onRewarded: (Reward reward) {
            add(EarnedReward(reward));
          },
        ),
      );

      await state.rewardedAd?.show();
      await state.rewardedAd?.waitForDismiss();

      emit(
        state.copyWith(
          status: FullScreenAdsStatus.showingRewardedAdSucceeded,
        ),
      );

      add(const LoadRewardedAdRequested());
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: FullScreenAdsStatus.showingRewardedAdFailed,
        ),
      );
      addError(error, stackTrace);
    }
  }

  void _onEarnedReward(
    EarnedReward event,
    Emitter<FullScreenAdsState> emit,
  ) =>
      emit(state.copyWith(earnedReward: event.reward));
}
