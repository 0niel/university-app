import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class SkeletonContributorCard extends StatelessWidget {
  const SkeletonContributorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 37,
              backgroundColor: AppColors.dark.deactive,
            ),
            const SizedBox(height: 16),
            Container(
              width: 100,
              height: 16,
              color: AppColors.dark.background03,
            ),
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 16,
              color: AppColors.dark.background03,
            ),
          ],
        ),
      ),
    );
  }
}
