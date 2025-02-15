import 'package:ads_ui/ads_ui.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:news_blocks/news_blocks.dart' as news_blocks;
import 'package:rtu_mirea_app/ads/ads.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template sticky_ad}
/// A bottom-anchored, adaptive ad widget.
/// https://developers.google.com/admob/flutter/banner/anchored-adaptive
/// {@endtemplate}
class StickyAd extends StatefulWidget {
  /// {@macro sticky_ad}
  const StickyAd({super.key});

  static const padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg + AppSpacing.xs,
    vertical: AppSpacing.lg,
  );

  @override
  State<StickyAd> createState() => _StickyAdState();
}

class _StickyAdState extends State<StickyAd> {
  var _adLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsBloc, AdsState>(
      builder: (context, adsState) {
        if (!adsState.showAds) {
          return const SizedBox.shrink();
        }
        final deviceWidth = MediaQuery.of(context).size.width;
        final adWidth = (deviceWidth - StickyAd.padding.left - StickyAd.padding.right).truncate();

        return StickyAdContainer(
          key: const Key('stickyAd_container'),
          shadowEnabled: _adLoaded,
          child: BannerAdContent(
            size: news_blocks.BannerSize.anchoredAdaptive,
            anchoredAdaptiveWidth: adWidth,
            onAdLoaded: () => setState(() => _adLoaded = true),
            showProgressIndicator: false,
            adUnitId: 'R-M-6720695-2',
          ),
        );
      },
    );
  }
}

@visibleForTesting
class StickyAdContainer extends StatelessWidget {
  const StickyAdContainer({
    required this.child,
    required this.shadowEnabled,
    super.key,
  });

  final Widget child;
  final bool shadowEnabled;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppColors>()!.background01,
      ),
      child: child,
    );
  }
}

class StickyAdCloseIcon extends StatelessWidget {
  const StickyAdCloseIcon({
    required this.onAdClosed,
    super.key,
  });

  final VoidCallback onAdClosed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppSpacing.lg,
      child: GestureDetector(
        onTap: onAdClosed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).extension<AppColors>()!.active,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxs),
            child: Icon(Icons.close, color: Theme.of(context).extension<AppColors>()!.background03),
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class StickyAdCloseIconBackground extends StatelessWidget {
  const StickyAdCloseIconBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppSpacing.lg,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 3,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.xxs),
          child: HugeIcon(icon: HugeIcons.strokeRoundedClosedCaption, color: Colors.white),
        ),
      ),
    );
  }
}
