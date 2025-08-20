import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopicsSkeletonCard extends StatelessWidget {
  const TopicsSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final maxWidth = min(320.0, MediaQuery.of(context).size.width - 64);

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 0, maxWidth: maxWidth),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).extension<AppColors>()!.background02,
        ),
        padding: const EdgeInsets.all(16),
        child: Skeletonizer(
          effect: ShimmerEffect(
            baseColor: colors.shimmerBase,
            highlightColor: colors.shimmerHighlight,
          ),
          child: SizedBox(
            height: 220,
            width: max(320, MediaQuery.of(context).size.width - 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 96,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.background02,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: colors.background02,
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: maxWidth - 64 - 16 - 16,
                          decoration: BoxDecoration(
                            color: colors.background02,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 16,
                          width: max(0.0, (maxWidth - 64 - 16 - 16) * 0.75),
                          decoration: BoxDecoration(
                            color: colors.background02,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
