import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'section_header_skeleton.dart';

class NinjaGroupSpaceSkeleton extends StatelessWidget {
  const NinjaGroupSpaceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final grow = (MediaQuery.textScalerOf(context).scale(1) - 1).clamp(0, 1);
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const .fromLTRB(
          AppSpacing.screen,
          12,
          AppSpacing.screen,
          24,
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            NinjaSkeleton(
              height: 88 + grow * 44,
              radius: AppRadius.card,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (var i = 0; i < 4; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  const Expanded(
                    child: NinjaSkeleton(
                      height: 48,
                      radius: AppRadius.banner,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const NinjaSkeleton(height: 44, radius: AppRadius.full),
            const SizedBox(height: 18),
            NinjaSkeleton(height: 64 + grow * 32, radius: AppRadius.card),
            const _SectionHeaderSkeleton(),
            NinjaSkeleton(height: 92 + grow * 48, radius: AppRadius.card),
            const _SectionHeaderSkeleton(),
            NinjaSkeleton(height: 64 + grow * 32, radius: AppRadius.card),
            const _SectionHeaderSkeleton(),
            NinjaSkeleton(height: 52 + grow * 26, radius: AppRadius.card),
            const _SectionHeaderSkeleton(),
            NinjaSkeleton(height: 64 + grow * 32, radius: AppRadius.card),
            const SizedBox(height: 10),
            NinjaSkeleton(height: 132 + grow * 60, radius: AppRadius.card),
          ],
        ),
      ),
    );
  }
}
