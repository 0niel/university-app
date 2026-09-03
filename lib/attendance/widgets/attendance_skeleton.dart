import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AttendanceSkeleton extends StatelessWidget {
  const AttendanceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const NinjaSkeletonGroup(
      child: Padding(
        padding: EdgeInsets.only(top: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: NinjaSkeleton(height: 72, radius: AppRadius.lg),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: NinjaSkeleton(height: 72, radius: AppRadius.lg),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: NinjaSkeleton(height: 72, radius: AppRadius.lg),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            NinjaSkeleton(height: 118, radius: AppRadius.card),
            SizedBox(height: AppSpacing.xxl),
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
