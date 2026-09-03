import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TeamListSkeleton extends StatelessWidget {
  const TeamListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonGroup(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
        itemCount: 3,
        itemBuilder: (itemContext, _) => Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            10,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: itemContext.colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton.bar(height: 11, widthFactor: 0.4),
                  AppSkeleton.bar(height: 20, widthFactor: 0.75),
                  AppSkeleton.bar(height: 11),
                  AppSkeleton.bar(height: 11, widthFactor: 0.6),
                  AppSkeletonRow(),
                  AppSkeleton(height: 44, radius: AppRadius.field),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
