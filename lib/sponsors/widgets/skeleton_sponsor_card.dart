import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonSponsorCard extends StatelessWidget {
  const SkeletonSponsorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).extension<AppColors>()!.background03,
      highlightColor: Theme.of(context).extension<AppColors>()!.background02,
      child: Card(
        color: Theme.of(context).extension<AppColors>()!.background02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const SizedBox(
          height: 72,
          width: double.infinity,
        ),
      ),
    );
  }
}
