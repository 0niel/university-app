import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Renders a widget containing a progress indicator that calls
/// [onPresented] when the item becomes visible.
class ArticleContentLoaderItem extends StatefulWidget {
  const ArticleContentLoaderItem({super.key, this.onPresented});

  /// A callback performed when the widget is presented.
  final VoidCallback? onPresented;

  @override
  State<ArticleContentLoaderItem> createState() =>
      _ArticleContentLoaderItemState();
}

class _ArticleContentLoaderItemState extends State<ArticleContentLoaderItem> {
  @override
  void initState() {
    super.initState();
    widget.onPresented?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    Widget textLine({required double width, double height = 14}) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: colors.background02,
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    Widget imagePlaceholder({double height = 200}) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Container(height: height, color: colors.background02),
      );
    }

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: colors.shimmerBase,
        highlightColor: colors.shimmerHighlight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            textLine(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 24,
            ),
            const SizedBox(height: AppSpacing.sm),
            textLine(width: MediaQuery.of(context).size.width * 0.6),
            const SizedBox(height: AppSpacing.md),
            imagePlaceholder(),
            const SizedBox(height: AppSpacing.md),
            textLine(width: MediaQuery.of(context).size.width * 0.9),
            const SizedBox(height: AppSpacing.xs),
            textLine(width: MediaQuery.of(context).size.width * 0.85),
            const SizedBox(height: AppSpacing.xs),
            textLine(width: MediaQuery.of(context).size.width * 0.7),
          ],
        ),
      ),
    );
  }
}
