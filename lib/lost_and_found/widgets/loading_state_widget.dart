import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildShimmerCard(context, hasImage: index % 2 == 0),
        );
      },
    );
  }

  Widget _buildShimmerCard(BuildContext context, {required bool hasImage}) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: hasImage ? 280 : 140,
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: appColors.cardShadowLight, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: appColors.shimmerBase,
        highlightColor: appColors.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder (for some cards)
            if (hasImage) Container(height: 180, width: double.infinity, color: Colors.white),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with status badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                            ),
                          ],
                        ),
                      ),

                      // Status badge
                      if (!hasImage) ...[
                        const SizedBox(width: 12),
                        Container(
                          height: 28,
                          width: 80,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Footer with date & contact chips
                  Row(
                    children: [
                      // Date chip
                      Container(
                        height: 28,
                        width: 90,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      ),

                      const Spacer(),

                      // Contact chip
                      Container(
                        height: 28,
                        width: 70,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
