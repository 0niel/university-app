import 'dart:async';

import 'package:ads_ui/ads_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:platform/platform.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

part 'full_screen_ads_event.dart';
part 'full_screen_ads_bloc.freezed.dart';
part 'full_screen_ads_status.dart';
part 'full_screen_ads_state.dart';

typedef YandexInterstitialAdLoader =
    Future<void> Function({
      required AdRequest adRequest,
      required void Function(InterstitialAd ad) onAdLoaded,
      required void Function(Object error) onAdFailedToLoad,
    });

typedef YandexRewardedAdLoader =
    Future<void> Function({
      required AdRequest adRequest,
      required void Function(RewardedAd ad) onAdLoaded,
      required void Function(Object error) onAdFailedToLoad,
    });

class FullScreenAdsBloc extends Bloc<FullScreenAdsEvent, FullScreenAdsState> {
  FullScreenAdsBloc({
    required this.adsRetryPolicy,
    required this.onLoadInterstitialAd,
    required this.onLoadRewardedAd,
    required this.localPlatform,
    FullScreenAdsConfig? fullScreenAdsConfig,
  }) : _fullScreenAdsConfig =
           fullScreenAdsConfig ?? const FullScreenAdsConfig(),
       super(const FullScreenAdsState()) {
    on<LoadInterstitialAdRequested>(_onLoadInterstitialAdRequested);
    on<LoadRewardedAdRequested>(_onLoadRewardedAdRequested);
    on<ShowInterstitialAdRequested>(
      _onShowInterstitialAdRequested,
      transformer: droppable(),
    );
    on<ShowRewardedAdRequested>(
      _onShowRewardedAdRequested,
      transformer: droppable(),
    );
    on<RewardEarned>(_onRewardEarned);
  }

  final AdsRetryPolicy adsRetryPolicy;
  final FullScreenAdsConfig _fullScreenAdsConfig;
  final YandexInterstitialAdLoader onLoadInterstitialAd;
  final YandexRewardedAdLoader onLoadRewardedAd;
  final LocalPlatform localPlatform;

  bool get _isSupportedPlatform =>
      localPlatform.isAndroid || localPlatform.isIOS;

  Future<void> _onLoadInterstitialAdRequested(
    LoadInterstitialAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    if (!_isSupportedPlatform) {
      return;
    }

    try {
      final adCompleter = Completer<InterstitialAd>();

      emit(state.copyWith(status: .loadingInterstitialAd));

      final adUnitId =
          _fullScreenAdsConfig.interstitialAdUnitId ??
          FullScreenAdsConfig.testInterstitialAdUnitId;

      await onLoadInterstitialAd(
        adRequest: AdRequest(adUnitId: adUnitId),
        onAdLoaded: adCompleter.complete,
        onAdFailedToLoad: (error) => adCompleter.completeError(error, .current),
      );

      final loadedAd = await adCompleter.future;

      emit(
        state.copyWith(
          interstitialAd: loadedAd,
          status: .loadingInterstitialAdSucceeded,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(
        state.copyWith(status: .loadingInterstitialAdFailed),
      );

      addError(error, stackTrace);

      if (event.retry < adsRetryPolicy.maxRetryCount) {
        final nextRetry = event.retry + 1;
        await Future<void>.delayed(
          adsRetryPolicy.getIntervalForRetry(nextRetry),
        );
        add(LoadInterstitialAdRequested(retry: nextRetry));
      }
    }
  }

  Future<void> _onLoadRewardedAdRequested(
    LoadRewardedAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    if (!_isSupportedPlatform) {
      return;
    }

    try {
      final adCompleter = Completer<RewardedAd>();

      emit(state.copyWith(status: .loadingRewardedAd));

      final adUnitId =
          _fullScreenAdsConfig.rewardedAdUnitId ??
          FullScreenAdsConfig.testRewardedAdUnitId;

      await onLoadRewardedAd(
        adRequest: AdRequest(adUnitId: adUnitId),
        onAdLoaded: adCompleter.complete,
        onAdFailedToLoad: (error) => adCompleter.completeError(error, .current),
      );

      final loadedAd = await adCompleter.future;

      emit(
        state.copyWith(
          rewardedAd: loadedAd,
          status: .loadingRewardedAdSucceeded,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .loadingRewardedAdFailed));

      addError(error, stackTrace);

      if (event.retry < adsRetryPolicy.maxRetryCount) {
        final nextRetry = event.retry + 1;
        await Future<void>.delayed(
          adsRetryPolicy.getIntervalForRetry(nextRetry),
        );
        add(LoadRewardedAdRequested(retry: nextRetry));
      }
    }
  }

  Future<void> _onShowInterstitialAdRequested(
    ShowInterstitialAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    if (!_isSupportedPlatform) {
      return;
    }

    try {
      emit(state.copyWith(status: .showingInterstitialAd));

      await state.interstitialAd?.setAdEventListener(
        eventListener: InterstitialAdEventListener(
          onAdDismissed: () {
            unawaited(state.interstitialAd?.destroy());
          },
          onAdFailedToShow: (error) {
            unawaited(state.interstitialAd?.destroy());
            addError(error, .current);
          },
        ),
      );

      await state.interstitialAd?.show();
      await state.interstitialAd?.waitForDismiss();

      emit(
        state.copyWith(
          status: .showingInterstitialAdSucceeded,
        ),
      );

      add(const LoadInterstitialAdRequested());
    } on Exception catch (error, stackTrace) {
      emit(
        state.copyWith(status: .showingInterstitialAdFailed),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _onShowRewardedAdRequested(
    ShowRewardedAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    if (!_isSupportedPlatform) {
      return;
    }

    try {
      emit(state.copyWith(status: .showingRewardedAd));

      await state.rewardedAd?.setAdEventListener(
        eventListener: RewardedAdEventListener(
          onAdDismissed: () {
            unawaited(state.rewardedAd?.destroy());
          },
          onAdFailedToShow: (error) {
            unawaited(state.rewardedAd?.destroy());
            addError(error, .current);
          },
          onRewarded: (reward) {
            add(RewardEarned(reward));
          },
        ),
      );

      await state.rewardedAd?.show();
      await state.rewardedAd?.waitForDismiss();

      emit(
        state.copyWith(status: .showingRewardedAdSucceeded),
      );

      add(const LoadRewardedAdRequested());
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .showingRewardedAdFailed));
      addError(error, stackTrace);
    }
  }

  void _onRewardEarned(RewardEarned event, Emitter<FullScreenAdsState> emit) =>
      emit(state.copyWith(earnedReward: event.reward));
}
