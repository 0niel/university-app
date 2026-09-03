import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_stripe_placeholder.dart';
import 'package:flutter/widgets.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  });

  final double? height;
  final double? width;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: height,
      width: width,
      child: AppStripePlaceholder(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? (borderRadius ?? BorderRadius.circular(AppRadius.lg))
            : null,
        base: colors.surface2,
        stripe: colors.surface,
        child: AppLineIconWidget(
          AppLineIcon.image,
          size: AppIconSize.lg,
          color: colors.muted2,
        ),
      ),
    );
  }
}
