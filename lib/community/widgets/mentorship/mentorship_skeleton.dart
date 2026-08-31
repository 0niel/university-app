import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MentorshipSkeleton extends StatelessWidget {
  const MentorshipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: Column(
        children: [
          for (var index = 0; index < 3; index++)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                NinjaMetrics.screenPadding,
                0,
                NinjaMetrics.screenPadding,
                10,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.ninja.surface,
                  borderRadius: BorderRadius.circular(NinjaRadius.card),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: .start,
                    children: [
                      NinjaSkeletonRow(),
                      NinjaSkeleton.bar(height: 11),
                      NinjaSkeleton.bar(height: 11, widthFactor: 0.7),
                      NinjaSkeleton(height: 48, radius: NinjaRadius.pill),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
