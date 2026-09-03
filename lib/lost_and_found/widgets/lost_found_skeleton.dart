import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundSkeleton extends StatelessWidget {
  const LostFoundSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: AppListGroup(
        children: [
          for (var index = 0; index < 4; index++)
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  NinjaSkeleton(
                    width: 56,
                    height: 56,
                    radius: AppRadius.tile,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NinjaSkeleton(
                          height: 16,
                          width: 54,
                          radius: AppRadius.full,
                        ),
                        SizedBox(height: 7),
                        NinjaSkeleton.bar(widthFactor: .72, height: 13),
                        SizedBox(height: AppSpacing.xsm),
                        NinjaSkeleton.bar(widthFactor: .5, height: 11),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  NinjaSkeleton(width: 40, height: 40, radius: AppRadius.full),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
