import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopicsSkeletonCard extends StatelessWidget {
  const TopicsSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 320,
        maxWidth: MediaQuery.of(context).size.width - 64,
      ),
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
                  height: 128,
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
                          width: 240,
                          decoration: BoxDecoration(
                            color: colors.background02,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 16,
                          width: 128,
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
