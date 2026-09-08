import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MapSkeleton extends StatelessWidget {
  const MapSkeleton({super.key});

  @override
  Widget build(BuildContext context) => NinjaSkeletonGroup(
    child: CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            MediaQuery.paddingOf(context).top + AppSpacing.screenTop,
            AppSpacing.screen,
            AppBottomBar.extentOf(context) + AppSpacing.screen,
          ),
          sliver: const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                NinjaSkeleton(height: 50, radius: AppRadius.full),
                SizedBox(height: AppSpacing.gap),
                NinjaSkeleton(
                  height: 44,
                  widthFactor: .8,
                  radius: AppRadius.full,
                ),
                Spacer(),
                AppSkeletonRow(),
                AppSkeletonRow(),
                AppSkeletonRow(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
