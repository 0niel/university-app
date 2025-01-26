import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.height,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.child,
    this.enabled = true,
    this.withBackground = true,
  });

  final double? height;
  final double? width;
  final BorderRadius borderRadius;
  final Widget? child;
  final bool enabled;
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: enabled,
      baseColor: Theme.of(context).extension<AppColors>()!.background03,
      highlightColor: Theme.of(context).extension<AppColors>()!.background02,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: withBackground ? Theme.of(context).extension<AppColors>()!.background02 : null,
        ),
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
