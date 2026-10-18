import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_loading_plan.dart';

class MapSkeleton extends StatelessWidget {
  const MapSkeleton({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.isDark
        ? AppColors.mapCanvasDark
        : AppColors.mapCanvasLight,
    child: Padding(
      padding: EdgeInsets.only(bottom: AppBottomBar.extentOf(context)),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: MapLoadingPlan(
                    label: context.l10n.mapCampusPlanLoading,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
