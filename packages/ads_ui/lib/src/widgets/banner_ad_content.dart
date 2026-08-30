import 'dart:async';
import 'dart:developer';

import 'package:ads_ui/src/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:platform/platform.dart' as platform;
import 'package:yandex_mobileads/mobile_ads.dart';

typedef BannerAdBuilder =
    BannerAd Function({
      required BannerAdSize size,
      required String adUnitId,
      required AdRequest request,
      void Function()? onAdLoaded,
      void Function(AdRequestError error)? onAdFailedToLoad,
      void Function()? onAdClicked,
      void Function()? onLeftApplication,
      void Function()? onReturnedToApplication,
      void Function(ImpressionData impressionData)? onImpression,
    });

class BannerAdContent extends StatefulWidget {
  const BannerAdContent({
    required this.size,
    this.adFailedToLoadTitle,
    this.adsRetryPolicy = const AdsRetryPolicy(),
    this.anchoredAdaptiveWidth,
    this.adUnitIdAndroid,
    this.adUnitIdIOS,
    this.adBuilder = _defaultAdBuilder,
    this.currentPlatform = const platform.LocalPlatform(),
    this.onAdLoaded,
    this.showProgressIndicator = true,
    super.key,
  });

  final BannerSize size;
  final String? adFailedToLoadTitle;
  final AdsRetryPolicy adsRetryPolicy;
  final int? anchoredAdaptiveWidth;
  final String? adUnitIdAndroid;
  final String? adUnitIdIOS;
  final BannerAdBuilder adBuilder;
  final platform.Platform currentPlatform;
  final VoidCallback? onAdLoaded;
  final bool showProgressIndicator;
  @visibleForTesting
  static const testUnitId = 'demo-banner-yandex';

  @visibleForTesting
  static const String androidTestUnitId = testUnitId;
  static const String iosTestUnitAd = testUnitId;

  @override
  State<BannerAdContent> createState() => _BannerAdContentState();
}

BannerAd _defaultAdBuilder({
  required BannerAdSize size,
  required String adUnitId,
  required AdRequest request,
  void Function()? onAdLoaded,
  void Function(AdRequestError error)? onAdFailedToLoad,
  void Function()? onAdClicked,
  void Function()? onLeftApplication,
  void Function()? onReturnedToApplication,
  void Function(ImpressionData impressionData)? onImpression,
}) {
  return BannerAd(adSize: size);
}

class _BannerAdContentState extends State<BannerAdContent>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _ad;
  StreamSubscription<BannerAdLoadState>? _loadStateSubscription;
  StreamSubscription<BannerAdEvent>? _eventSubscription;
  bool _adFailedToLoad = false;
  bool _isBannerAlreadyCreated = false;
  bool _hasNotifiedAdLoaded = false;

  bool get _isSupportedPlatform =>
      !kIsWeb &&
      (widget.currentPlatform.isAndroid || widget.currentPlatform.isIOS);

  @override
  void initState() {
    super.initState();

    if (_isSupportedPlatform) {
      unawaited(YandexAds.initialize());
    }
  }

  @override
  void dispose() {
    unawaited(_loadStateSubscription?.cancel() ?? Future.value());
    unawaited(_eventSubscription?.cancel() ?? Future.value());
    final ad = _ad;
    if (ad != null) unawaited(ad.destroy());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_isBannerAlreadyCreated && !_adFailedToLoad) {
      unawaited(_loadAd());
    }
    final ad = _ad;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        if (_isBannerAlreadyCreated && ad != null)
          AdWidget(bannerAd: ad)
        else if (_adFailedToLoad)
          if (widget.adFailedToLoadTitle case final String title)
            Text(title)
          else
            const SizedBox.shrink()
        else if (widget.showProgressIndicator)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadAd() async {
    if (!_isSupportedPlatform) {
      return;
    }

    if (_isBannerAlreadyCreated) return;

    final currentAdSize = await _resolveAdSize();
    if (!mounted || _isBannerAlreadyCreated) return;

    final adUnitId = widget.currentPlatform.isAndroid
        ? (widget.adUnitIdAndroid ?? BannerAdContent.androidTestUnitId)
        : (widget.adUnitIdIOS ?? BannerAdContent.iosTestUnitAd);
    final bannerAd = widget.adBuilder(
      adUnitId: adUnitId,
      request: AdRequest(adUnitId: adUnitId),
      size: currentAdSize,
      onAdLoaded: () {
        if (!mounted) return;
        _notifyAdLoaded();
        log('callback: banner ad loaded', name: 'BannerAdContent');
      },
      onAdFailedToLoad: (error) {
        if (!mounted) return;
        setState(() {
          _adFailedToLoad = true;
        });
        log(
          'callback: banner ad failed to load, '
          'code: ${error.code}, description: ${error.description}',
          name: 'BannerAdContent',
        );
      },
      onAdClicked: () =>
          log('callback: banner ad clicked', name: 'BannerAdContent'),
      onLeftApplication: () =>
          log('callback: left app', name: 'BannerAdContent'),
      onReturnedToApplication: () =>
          log('callback: returned to app', name: 'BannerAdContent'),
      onImpression: (data) => log(
        'callback: impression: ${data.getRawData()}',
        name: 'BannerAdContent',
      ),
    );
    _ad = bannerAd;
    _listenToAdEvents(bannerAd);
    setState(() {
      _isBannerAlreadyCreated = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ad = _ad;
      if (ad != null) unawaited(ad.load(AdRequest(adUnitId: adUnitId)));
    });
  }

  void _listenToAdEvents(BannerAd ad) {
    final previousLoadStateSubscription = _loadStateSubscription;
    if (previousLoadStateSubscription != null) {
      unawaited(previousLoadStateSubscription.cancel());
    }
    _loadStateSubscription = ad.loadStateStream.listen((state) {
      if (!mounted) return;
      switch (state) {
        case BannerAdLoadStateLoaded():
          _notifyAdLoaded();
          log('callback: banner ad loaded', name: 'BannerAdContent');
        case BannerAdLoadStateError(:final error):
          setState(() {
            _adFailedToLoad = true;
          });
          log(
            'callback: banner ad failed to load, '
            'code: ${error.code}, description: ${error.description}',
            name: 'BannerAdContent',
          );
        case BannerAdLoadStateInitial():
        case BannerAdLoadStateLoading():
          break;
      }
    });

    final previousEventSubscription = _eventSubscription;
    if (previousEventSubscription != null) {
      unawaited(previousEventSubscription.cancel());
    }
    _eventSubscription = ad.events.listen((event) {
      switch (event) {
        case BannerAdClickedEvent():
          log('callback: banner ad clicked', name: 'BannerAdContent');
        case BannerAdImpressionEvent(:final impressionData):
          log(
            'callback: impression: ${impressionData.getRawData()}',
            name: 'BannerAdContent',
          );
      }
    });
  }

  Future<BannerAdSize> _resolveAdSize() async {
    switch (widget.size) {
      case BannerSize.anchoredAdaptive:
        final adWidth =
            widget.anchoredAdaptiveWidth ??
            MediaQuery.widthOf(context).truncate();
        final calculated = await BannerAdSize.sticky(
          width: adWidth,
        ).getCalculatedBannerAdSize();
        log('calculatedBannerSize: $calculated', name: 'BannerAdContent');
        return BannerAdSize.sticky(width: calculated.width);
      case BannerSize.normal:
        return BannerAdSize.sticky(width: GoogleAdSizes.banner.width);
      case BannerSize.large:
        return BannerAdSize.sticky(width: GoogleAdSizes.mediumRectangle.width);
      case BannerSize.extraLarge:
        return const BannerAdSize.sticky(width: 300);
    }
  }

  void _notifyAdLoaded() {
    if (_hasNotifiedAdLoaded) return;
    _hasNotifiedAdLoaded = true;
    widget.onAdLoaded?.call();
  }
}
