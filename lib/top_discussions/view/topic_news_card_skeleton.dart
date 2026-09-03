import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TopicNewsCardSkeleton extends StatelessWidget {
  const TopicNewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 296,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NinjaSkeleton.avatar(size: 22),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: NinjaSkeleton.bar(height: 11, widthFactor: 0.5)),
            ],
          ),
          SizedBox(height: AppSpacing.sectionGap),
          NinjaSkeleton.bar(),
          SizedBox(height: AppSpacing.sm),
          NinjaSkeleton.bar(widthFactor: 0.7),
          Spacer(),
          NinjaSkeleton.bar(height: 11, widthFactor: 0.35),
        ],
      ),
    );
  }
}
