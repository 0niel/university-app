import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Renders a widget containing a progress indicator that calls
/// [onPresented] when the item becomes visible.
class CategoryFeedLoaderItem extends StatefulWidget {
  const CategoryFeedLoaderItem({super.key, this.onPresented});

  /// A callback performed when the widget is presented.
  final VoidCallback? onPresented;

  @override
  State<CategoryFeedLoaderItem> createState() => _CategoryFeedLoaderItemState();
}

class _CategoryFeedLoaderItemState extends State<CategoryFeedLoaderItem> {
  @override
  void initState() {
    super.initState();
    widget.onPresented?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    Widget modernFeedSkeletonCard() {
      return Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.background02,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media thumbnail with optimized aspect ratio
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.shimmerBase,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title lines
                  Container(
                    height: 22,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: colors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    height: 22,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: colors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Description lines
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: colors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: colors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Footer (author/date)
                  Container(
                    height: 14,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: colors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget compactSkeletonCard() {
      return Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.background02,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: colors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: colors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    height: 12,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: colors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.shimmerBase,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Skeletonizer(
        enabled: true,
        effect: ShimmerEffect(
          baseColor: colors.shimmerBase,
          highlightColor: colors.shimmerHighlight,
          duration: const Duration(milliseconds: 1200),
        ),
        child: Column(
          children: [
            modernFeedSkeletonCard(),
            compactSkeletonCard(),
            compactSkeletonCard(),
          ],
        ),
      ),
    );
  }
}
