import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CoworkSkeleton extends StatelessWidget {
  const CoworkSkeleton({super.key});

  static const double chipsHeight = 35;
  static const double seatMapHeight = 311;
  static const double detailsHeight = 108;

  @override
  Widget build(BuildContext context) {
    return const NinjaSkeletonGroup(
      child: Padding(
        padding: EdgeInsets.only(top: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NinjaSkeleton(height: chipsHeight, radius: AppRadius.full),
            SizedBox(height: AppSpacing.sectionGap),
            NinjaSkeleton(height: seatMapHeight, radius: AppRadius.card),
            SizedBox(height: AppSpacing.cardGap),
            NinjaSkeleton(height: detailsHeight, radius: AppRadius.row),
            SizedBox(height: AppSpacing.sectionGap),
            NinjaSkeleton(
              height: AppControlSize.buttonLarge,
              radius: AppRadius.full,
            ),
          ],
        ),
      ),
    );
  }
}
