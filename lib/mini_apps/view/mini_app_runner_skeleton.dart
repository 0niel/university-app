import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MiniAppRunnerSkeleton extends StatelessWidget {
  const MiniAppRunnerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = context.colors.surface;
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          ninjaBottomInset(context) + AppSpacing.lg,
        ),
        children: [
          const NinjaSkeleton.bar(height: 22, widthFactor: 0.5),
          const SizedBox(height: AppSpacing.sm),
          const NinjaSkeleton.bar(widthFactor: 0.7),
          const SizedBox(height: AppSpacing.sectionGap),
          _Card(
            surface: surface,
            child: const Row(
              children: [
                NinjaSkeleton(width: 52, height: 52, radius: AppRadius.banner),
                SizedBox(width: AppSpacing.sectionGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      NinjaSkeleton.bar(height: 16, widthFactor: 0.6),
                      NinjaSkeleton.bar(height: 11),
                      NinjaSkeleton.bar(height: 11, widthFactor: 0.7),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Row(
            spacing: AppSpacing.sm,
            children: [
              NinjaSkeleton(width: 84, height: 36, radius: AppRadius.full),
              NinjaSkeleton(width: 72, height: 36, radius: AppRadius.full),
              NinjaSkeleton(width: 96, height: 36, radius: AppRadius.full),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _Card(
            surface: surface,
            child: const Column(
              crossAxisAlignment: .stretch,
              spacing: 12,
              children: [
                NinjaSkeleton.bar(height: 13, widthFactor: 0.38),
                NinjaSkeleton(height: 48, radius: AppRadius.field),
                NinjaSkeleton(height: 48, radius: AppRadius.field),
                NinjaSkeleton(height: 48, radius: AppRadius.field),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const NinjaSkeleton(height: 48, radius: AppRadius.full),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.surface, required this.child});

  final Color surface;
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
    ),
    child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: child),
  );
}
