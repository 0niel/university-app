import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventsCalendarSkeleton extends StatelessWidget {
  const EventsCalendarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: NinjaSkeleton.bar(widthFactor: .4, height: 20),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    NinjaSkeleton(
                      height: AppControlSize.iconButton,
                      width: AppControlSize.iconButton,
                      radius: AppRadius.full,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    NinjaSkeleton(
                      height: AppControlSize.iconButton,
                      width: AppControlSize.iconButton,
                      radius: AppRadius.full,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                for (var row = 0; row < 5; row++) ...[
                  if (row > 0) const SizedBox(height: AppSpacing.xxs),
                  Row(
                    children: [
                      for (var column = 0; column < 7; column++) ...[
                        if (column > 0) const SizedBox(width: AppSpacing.xxs),
                        const Expanded(
                          child: NinjaSkeleton(
                            height: AppControlSize.navCircle,
                            radius: AppRadius.iconTile,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.cardGap),
          const AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [AppSkeletonRow(), AppSkeletonRow()],
            ),
          ),
        ],
      ),
    );
  }
}
