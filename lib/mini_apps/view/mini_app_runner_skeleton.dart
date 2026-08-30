import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MiniAppRunnerSkeleton extends StatelessWidget {
  const MiniAppRunnerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView(
        padding: const .all(NinjaMetrics.screenPadding),
        children: [
          const NinjaSkeleton(height: 28, radius: NinjaRadius.button),
          const SizedBox(height: 14),
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.ninja.surface,
              borderRadius: .circular(NinjaRadius.card),
            ),
            child: const Padding(
              padding: .all(18),
              child: Row(
                children: [
                  NinjaSkeleton(width: 52, height: 52, radius: 16),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 8,
                      children: [
                        NinjaSkeleton.bar(height: 18, widthFactor: 0.6),
                        NinjaSkeleton.bar(height: 11),
                        NinjaSkeleton.bar(height: 11, widthFactor: 0.7),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.ninja.surface,
              borderRadius: .circular(NinjaRadius.card),
            ),
            child: const Padding(
              padding: .all(16),
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: 12,
                children: [
                  NinjaSkeleton.bar(height: 13, widthFactor: 0.38),
                  NinjaSkeleton(height: 48, radius: NinjaRadius.control),
                  NinjaSkeleton(height: 48, radius: NinjaRadius.control),
                  NinjaSkeleton(height: 48, radius: NinjaRadius.control),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          const NinjaSkeleton(height: 56, radius: NinjaRadius.button),
        ],
      ),
    );
  }
}
