import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TeamApplicationsSkeleton extends StatelessWidget {
  const TeamApplicationsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: Column(
        children: [
          for (var index = 0; index < 3; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.ninja.surface,
                  borderRadius: BorderRadius.circular(NinjaRadius.card),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: .start,
                    children: [
                      NinjaSkeletonRow(),
                      NinjaSkeleton.bar(height: 11),
                      NinjaSkeleton(height: 48, radius: NinjaRadius.control),
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
