import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonContributorCard extends StatelessWidget {
  const SkeletonContributorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Skeletonizer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 37, backgroundColor: colors.background03),
            const SizedBox(height: 16),
            Container(width: 100, height: 16, color: colors.background02),
            const SizedBox(height: 8),
            Container(width: 100, height: 16, color: colors.background02),
          ],
        ),
      ),
    );
  }
}
