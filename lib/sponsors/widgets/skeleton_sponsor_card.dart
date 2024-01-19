import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonSponsorCard extends StatelessWidget {
  const SkeletonSponsorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.colorsOf(context).background03,
      highlightColor: AppTheme.colorsOf(context).background02,
      child: Card(
        color: AppTheme.colorsOf(context).background02,
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
