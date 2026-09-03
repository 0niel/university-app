import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_layout.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventsSkeleton extends StatelessWidget {
  const EventsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        children: [
          for (var index = 0; index < 3; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.cardGap),
            const AppCard(
              radius: AppRadius.row,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NinjaSkeleton(
                        height: EventLayout.emojiTileSize,
                        width: EventLayout.emojiTileSize,
                        radius: AppRadius.field,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NinjaSkeleton.bar(widthFactor: .4, height: 18),
                            SizedBox(height: AppSpacing.sm),
                            NinjaSkeleton.bar(widthFactor: .7, height: 16),
                            SizedBox(height: AppSpacing.xs),
                            NinjaSkeleton.bar(widthFactor: .5),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sectionGap),
                  Row(
                    children: [
                      NinjaSkeleton(height: 12.5, width: 90),
                      Spacer(),
                      NinjaSkeleton(
                        height: EventLayout.rsvpHeight,
                        width: 96,
                        radius: AppRadius.full,
                      ),
                    ],
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
