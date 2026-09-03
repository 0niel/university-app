import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CommunityCatalogSkeleton extends StatelessWidget {
  const CommunityCatalogSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              NinjaSkeleton(width: 60, height: 35, radius: AppRadius.full),
              NinjaSkeleton(width: 76, height: 35, radius: AppRadius.full),
              NinjaSkeleton(width: 64, height: 35, radius: AppRadius.full),
            ],
          ),
          SizedBox(height: AppSpacing.xlg),
          NinjaSkeleton.bar(height: 14, widthFactor: .24),
          SizedBox(height: AppSpacing.md),
          AppListGroup(
            children: [
              _SavedRowSkeleton(),
              _SavedRowSkeleton(),
            ],
          ),
          SizedBox(height: AppSpacing.xlg),
          NinjaSkeleton.bar(height: 14, widthFactor: .42),
          SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    NinjaSkeleton(
                      width: AppControlSize.field,
                      height: AppControlSize.field,
                      radius: AppRadius.banner,
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NinjaSkeleton.bar(height: 16, widthFactor: .8),
                          SizedBox(height: AppSpacing.xxs),
                          NinjaSkeleton.bar(widthFactor: .55),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                NinjaSkeleton.bar(height: 13.5),
                SizedBox(height: AppSpacing.xs),
                NinjaSkeleton.bar(height: 13.5, widthFactor: .7),
                SizedBox(height: AppSpacing.md),
                NinjaSkeleton(
                  height: AppControlSize.iconButtonCompact,
                  radius: AppRadius.full,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedRowSkeleton extends StatelessWidget {
  const _SavedRowSkeleton();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    child: Row(
      children: [
        NinjaSkeleton(
          width: AppControlSize.iconButton,
          height: AppControlSize.iconButton,
          radius: AppRadius.tile,
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NinjaSkeleton.bar(height: 14.5, widthFactor: .6),
              SizedBox(height: AppSpacing.xxs),
              NinjaSkeleton.bar(widthFactor: .4),
            ],
          ),
        ),
      ],
    ),
  );
}
