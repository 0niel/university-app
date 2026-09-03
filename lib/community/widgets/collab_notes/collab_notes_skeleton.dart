import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNotesSkeleton extends StatelessWidget {
  const CollabNotesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.zero,
          AppSpacing.screen,
          ninjaBottomInset(context) + AppSpacing.lg,
        ),
        children: [
          AppListGroup(
            children: [
              for (var index = 0; index < 6; index++)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      AppSkeleton(
                        width: 44,
                        height: 44,
                        radius: AppRadius.tile,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            AppSkeleton.bar(height: 14.5, widthFactor: 0.75),
                            AppSkeleton.bar(widthFactor: 0.5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
