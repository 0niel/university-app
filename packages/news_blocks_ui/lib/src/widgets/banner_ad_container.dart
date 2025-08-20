import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template banner_ad_container}
/// A reusable banner ad container widget.
/// {@endtemplate}
class BannerAdContainer extends StatelessWidget {
  /// {@macro banner_ad_container}
  const BannerAdContainer({
    required this.isNormal,
    required this.child,
    super.key,
  });

  /// Whether this banner ad uses the normal size paddings.
  final bool isNormal;

  /// The [Widget] displayed in this container.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isNormal
        ? AppSpacing.lg + AppSpacing.xs
        : AppSpacing.xlg + AppSpacing.xs + AppSpacing.xxs;

    final verticalPadding =
        isNormal ? AppSpacing.lg : AppSpacing.xlg + AppSpacing.sm;

    return DecoratedBox(
      key: const Key('bannerAdContainer_coloredBox'),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppColors>()!.surfaceHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: child,
      ),
    );
  }
}
