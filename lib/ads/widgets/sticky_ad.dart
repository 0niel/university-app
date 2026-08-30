import 'package:ads_ui/ads_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart' as news_blocks;
import 'package:rtu_mirea_app/ads/ads.dart';

class StickyAd extends StatelessWidget {
  const StickyAd({super.key});

  static const padding = EdgeInsets.symmetric(
    horizontal: 16 + 4,
    vertical: 16,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsBloc, AdsState>(
      builder: (context, adsState) {
        if (!adsState.showAds) {
          return const SizedBox.shrink();
        }
        final deviceWidth = MediaQuery.widthOf(context);
        final adWidth =
            (deviceWidth - StickyAd.padding.left - StickyAd.padding.right)
                .truncate();

        return StickyAdContainer(
          key: const Key('stickyAd_container'),
          child: BannerAdContent(
            size: news_blocks.BannerSize.anchoredAdaptive,
            anchoredAdaptiveWidth: adWidth,
            showProgressIndicator: false,
            adUnitIdAndroid: 'R-M-6720695-2',
            adUnitIdIOS: 'R-M-6721030-1',
          ),
        );
      },
    );
  }
}
