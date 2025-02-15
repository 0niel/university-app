import 'dart:async';

import 'package:ads_ui/src/widgets/widgets.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:platform/platform.dart' as platform;
import 'package:yandex_mobileads/mobile_ads.dart';

/// {@template banner_ad_failed_to_load_exception}
/// An exception thrown when loading a banner ad fails.
/// {@endtemplate}
class BannerAdFailedToLoadException implements Exception {
  /// {@macro banner_ad_failed_to_load_exception}
  BannerAdFailedToLoadException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template banner_ad_failed_to_get_size_exception}
/// An exception thrown when getting a banner ad size fails.
/// {@endtemplate}
class BannerAdFailedToGetSizeException implements Exception {
  /// {@macro banner_ad_failed_to_get_size_exception}
  BannerAdFailedToGetSizeException();
}

/// Signature for [BannerAd] builder.
typedef BannerAdBuilder = BannerAd Function({
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

/// {@template banner_ad_content}
/// A reusable content of a banner ad.
/// {@endtemplate}
class BannerAdContent extends StatefulWidget {
  /// {@macro banner_ad_content}
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

  /// The size of this banner ad.
  final BannerSize size;

  /// The title displayed when this ad fails to load.
  final String? adFailedToLoadTitle;

  /// The retry policy for loading.
  final AdsRetryPolicy adsRetryPolicy;

  /// The width of this banner ad for [BannerAdSize.anchoredAdaptive].
  /// Defaults to the width of the device.
  final int? anchoredAdaptiveWidth;

  /// The unit id of this banner ad on Android.
  /// Defaults to [androidTestUnitId].
  final String? adUnitIdAndroid;

  /// The unit id of this banner ad on iOS.
  /// Defaults to [iosTestUnitAd].
  final String? adUnitIdIOS;

  /// The builder of this banner ad.
  final BannerAdBuilder adBuilder;

  /// The current platform where this banner ad is displayed.
  final platform.Platform currentPlatform;

  /// Called once when this banner ad loads.
  final VoidCallback? onAdLoaded;

  /// Whether the progress indicator should be shown when the ad is loading.
  final bool showProgressIndicator;

  /// The Android test unit id of this banner ad.
  @visibleForTesting
  static const androidTestUnitId = 'demo-banner-yandex';

  /// The iOS test unit id of this banner ad.
  @visibleForTesting
  static const iosTestUnitAd = 'demo-banner-yandex';

  /// The size values of this banner ad.
  static final _sizeValues = <BannerSize, BannerAdSize>{
    BannerSize.normal: BannerAdSize.sticky(
      width: GoogleAdSizes.banner.width,
    ),
    BannerSize.large: BannerAdSize.sticky(
      width: GoogleAdSizes.mediumRectangle.width,
    ),
    BannerSize.extraLarge: const BannerAdSize.sticky(width: 300),
  };

  @override
  State<BannerAdContent> createState() => _BannerAdContentState();
}

/// A default [BannerAdBuilder] that uses the Yandex Mobile Ads [BannerAd.new]
/// constructor.
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
  return BannerAd(
    adUnitId: adUnitId,
    adSize: size,
    adRequest: request,
    onAdLoaded: onAdLoaded,
    onAdFailedToLoad: onAdFailedToLoad,
    onAdClicked: onAdClicked,
    onLeftApplication: onLeftApplication,
    onReturnedToApplication: onReturnedToApplication,
    onImpression: onImpression,
  );
}

class _BannerAdContentState extends State<BannerAdContent> with AutomaticKeepAliveClientMixin {
  BannerAd? _ad;
  bool _adFailedToLoad = false;
  bool _isBannerAlreadyCreated = false;
  final AdRequest _adRequest = const AdRequest();

  @override
  void dispose() {
    _ad?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_isBannerAlreadyCreated && !_adFailedToLoad) {
      _loadAd();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        if (_isBannerAlreadyCreated)
          AdWidget(bannerAd: _ad!)
        else if (_adFailedToLoad && widget.adFailedToLoadTitle != null)
          Text(widget.adFailedToLoadTitle!)
        else
          const SizedBox(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadAd() async {
    final windowSize = MediaQuery.of(context).size;
    setState(() {});

    BannerAdSize currentAdSize;
    if (widget.size == BannerSize.anchoredAdaptive) {
      final adWidth = widget.anchoredAdaptiveWidth ?? windowSize.width.truncate();
      final candidateSize = BannerAdSize.sticky(
        width: adWidth,
      );
      final calculated = await candidateSize.getCalculatedBannerAdSize();
      debugPrint('calculatedBannerSize: $calculated');
      currentAdSize = candidateSize;
    } else {
      currentAdSize = BannerAdContent._sizeValues[widget.size]!;
    }
    setState(() {});

    if (_isBannerAlreadyCreated) {
      await _ad?.loadAd(adRequest: _adRequest);
    } else {
      final adUnitId = widget.currentPlatform.isAndroid
          ? widget.adUnitIdAndroid ?? BannerAdContent.androidTestUnitId
          : widget.adUnitIdIOS ?? BannerAdContent.iosTestUnitAd;
      _ad = widget.adBuilder(
        adUnitId: adUnitId,
        request: _adRequest,
        size: currentAdSize,
        onAdLoaded: () {
          if (!mounted) return;
          setState(() {});
          widget.onAdLoaded?.call();
          debugPrint('callback: banner ad loaded');
        },
        onAdFailedToLoad: (error) {
          if (!mounted) return;
          setState(() {
            _adFailedToLoad = true;
          });
          debugPrint('callback: banner ad failed to load, '
              'code: ${error.code}, description: ${error.description}');
        },
        onAdClicked: () => debugPrint('callback: banner ad clicked'),
        onLeftApplication: () => debugPrint('callback: left app'),
        onReturnedToApplication: () => debugPrint('callback: returned to app'),
        onImpression: (data) => debugPrint('callback: impression: ${data.getRawData()}'),
      )..loadAd(adRequest: _adRequest);
      setState(() {
        _isBannerAlreadyCreated = true;
      });
    }
  }

  // ignore: unused_element
  void _reportError(Object exception, StackTrace stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: exception,
        stack: stackTrace,
      ),
    );
  }
}
