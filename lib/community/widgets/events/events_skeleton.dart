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
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NinjaSkeletonMedia(
                    height: EventLayout.coverHeight,
                    radius: AppRadius.row,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sectionGap,
                      AppSpacing.lg,
                      AppSpacing.sectionGap,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NinjaSkeleton.bar(widthFactor: .7, height: 16),
                        SizedBox(height: AppSpacing.sm),
                        NinjaSkeleton.bar(widthFactor: .5),
                        SizedBox(height: AppSpacing.gap),
                        Row(
                          children: [
                            NinjaSkeleton(height: 12.5, width: 72),
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
              ),
            ),
          ],
        ],
      ),
    );
  }
}
