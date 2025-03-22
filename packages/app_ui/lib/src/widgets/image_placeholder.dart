import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

/// A skeleton widget that shows a shimmering loading effect
class ImagePlaceholder extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  const ImagePlaceholder({
    super.key,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: appColors.background03,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? (borderRadius ?? BorderRadius.circular(16)) : null,
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: appColors.deactive.withOpacity(0.5),
        ),
      ),
    );
  }
}
