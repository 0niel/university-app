import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TeamApplicationsSkeleton extends StatelessWidget {
  const TeamApplicationsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonGroup(
      child: Column(
        children: [
          for (var index = 0; index < 3; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSkeletonRow(),
                      AppSkeleton.bar(height: 11),
                      AppSkeleton(height: 44, radius: AppRadius.field),
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
