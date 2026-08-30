import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class LostFoundItemSkeleton extends StatelessWidget {
  const LostFoundItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(NinjaRadius.card),
      child: ColoredBox(
        color: context.ninja.surface,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  NinjaSkeletonMedia(
                    height: double.infinity,
                    radius: NinjaRadius.card,
                    markSize: 36,
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: NinjaSkeleton(
                        width: 74,
                        height: 24,
                        radius: NinjaRadius.pill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NinjaSkeleton.bar(widthFactor: 0.78),
                  SizedBox(height: AppSpacing.sm),
                  NinjaSkeleton.bar(height: 11, widthFactor: 0.54),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
