import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MiniAppCardSkeleton extends StatelessWidget {
  const MiniAppCardSkeleton({this.featured = false, super.key});

  final bool featured;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final titleHeight = 20 * textScale;
    final detailHeight = 17 * textScale;
    return AppGlassSurface(
      tone: featured ? AppGlassTone.accent : AppGlassTone.subtle,
      borderRadius: 24,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const NinjaSkeleton(width: 48, height: 48, radius: 15),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NinjaSkeleton.bar(height: titleHeight, widthFactor: .65),
                const SizedBox(height: 3),
                NinjaSkeleton.bar(height: detailHeight),
                const SizedBox(height: 6),
                NinjaSkeleton.bar(height: 14 * textScale, widthFactor: .45),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const NinjaSkeleton(width: 18, height: 18, radius: 6),
        ],
      ),
    );
  }
}
