import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class BestMatchSkeletonCard extends StatelessWidget {
  const BestMatchSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final height = 156 + (scale - 1).clamp(0, 1).toDouble() * 68;
    final colors = context.ninja;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: SizedBox(
        height: height,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  NinjaSkeleton(
                    width: 44,
                    height: 44,
                    radius: NinjaRadius.control,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: NinjaSkeleton.bar(height: 13, widthFactor: 0.42),
                  ),
                  SizedBox(width: AppSpacing.md),
                  NinjaSkeleton.avatar(),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              NinjaSkeleton.bar(height: 22, widthFactor: .84),
              SizedBox(height: AppSpacing.sm),
              NinjaSkeleton.bar(widthFactor: .5),
            ],
          ),
        ),
      ),
    );
  }
}
