import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class GradesSkeleton extends StatelessWidget {
  const GradesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const NinjaSkeletonGroup(
      child: Padding(
        padding: EdgeInsets.only(top: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NinjaSkeleton(height: 96, radius: AppRadius.hero),
            SizedBox(height: AppSpacing.sm),
            NinjaSkeleton(height: 46, radius: AppRadius.full),
            SizedBox(height: AppSpacing.sm),
            NinjaSkeleton(height: 72, radius: AppRadius.row),
            SizedBox(height: AppSpacing.sm),
            NinjaSkeleton(height: 72, radius: AppRadius.row),
            SizedBox(height: AppSpacing.sm),
            NinjaSkeleton(height: 72, radius: AppRadius.row),
          ],
        ),
      ),
    );
  }
}
