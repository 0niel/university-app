import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_loading_plan.dart';

class MapSkeleton extends StatelessWidget {
  const MapSkeleton({super.key});

  @override
  Widget build(BuildContext context) => NinjaSkeletonGroup(
    semanticsLabel: context.l10n.mapCampusPlanLoading,
    child: ColoredBox(
      color: context.colors.canvas,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final insets = MediaQuery.paddingOf(context);
          final bottom = AppBottomBar.extentOf(context) + AppSpacing.lg;
          return Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xlg,
                  insets.top + 72,
                  AppSpacing.xlg,
                  bottom + 72,
                ),
                child: const MapLoadingPlan(),
              ),
              Positioned(
                top: insets.top + AppSpacing.sm,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: const Row(
                  children: [
                    NinjaSkeleton.avatar(),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: NinjaSkeleton(
                          height: 40,
                          width: 132,
                          radius: AppRadius.full,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    NinjaSkeleton.avatar(),
                  ],
                ),
              ),
              if (constraints.maxHeight - insets.top - bottom > 300)
                Positioned(
                  right: AppSpacing.lg,
                  top: insets.top + 96,
                  child: const Column(
                    children: [
                      NinjaSkeleton.avatar(),
                      SizedBox(height: AppSpacing.sm),
                      NinjaSkeleton.avatar(),
                    ],
                  ),
                ),
              Positioned(
                bottom: bottom,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: Align(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 360),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Row(
                      children: [
                        const AppSpinner(size: 20),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            context.l10n.mapCampusPlanLoading,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.body.copyWith(
                              color: context.colors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
