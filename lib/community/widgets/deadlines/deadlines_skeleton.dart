import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

part 'skeleton/deadline_skeleton_row.dart';

class DeadlinesSkeleton extends StatelessWidget {
  const DeadlinesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          NinjaMetrics.screenPadding,
          16,
          NinjaMetrics.screenPadding,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.ninja.surface,
                borderRadius: BorderRadius.circular(NinjaRadius.card),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NinjaSkeleton(height: 22, widthFactor: 0.55),
                              SizedBox(height: 8),
                              NinjaSkeleton.bar(widthFactor: 0.32),
                            ],
                          ),
                        ),
                        NinjaSkeleton(
                          width: 120,
                          height: 44,
                          radius: NinjaRadius.pill,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    NinjaSkeleton(height: 6, radius: NinjaRadius.pill),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                NinjaSkeleton(width: 76, height: 44, radius: NinjaRadius.pill),
                SizedBox(width: 8),
                NinjaSkeleton(width: 68, height: 44, radius: NinjaRadius.pill),
                SizedBox(width: 8),
                NinjaSkeleton(width: 84, height: 44, radius: NinjaRadius.pill),
              ],
            ),
            const SizedBox(height: 28),
            const NinjaSkeleton(height: 20, width: 120),
            const SizedBox(height: 10),
            const _DeadlineSkeletonRow(),
            const SizedBox(height: 10),
            const _DeadlineSkeletonRow(showProgress: true),
            const SizedBox(height: 10),
            const _DeadlineSkeletonRow(),
          ],
        ),
      ),
    );
  }
}
