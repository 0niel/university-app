import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class PollsSkeleton extends StatelessWidget {
  const PollsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        children: [
          for (var index = 0; index < 3; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.cardGap),
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NinjaSkeleton.bar(widthFactor: .4, height: 10),
                  SizedBox(height: AppSpacing.sectionGap),
                  NinjaSkeleton.bar(widthFactor: .85, height: 16),
                  SizedBox(height: AppSpacing.sm),
                  NinjaSkeleton.bar(widthFactor: .65),
                  SizedBox(height: AppSpacing.md),
                  NinjaSkeleton.bar(widthFactor: .5, height: 10),
                  SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: NinjaSkeleton(
                      width: 92,
                      height: 44,
                      radius: AppRadius.tile,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
