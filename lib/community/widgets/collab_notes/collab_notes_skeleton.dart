import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNotesSkeleton extends StatelessWidget {
  const CollabNotesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const .fromLTRB(
          AppSpacing.screen,
          AppSpacing.zero,
          AppSpacing.screen,
          96,
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
                      NinjaSkeleton(
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
                            NinjaSkeleton.bar(height: 14.5, widthFactor: 0.75),
                            NinjaSkeleton.bar(widthFactor: 0.5),
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
