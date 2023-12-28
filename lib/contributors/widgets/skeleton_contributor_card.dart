import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonContributorCard extends StatelessWidget {
  const SkeletonContributorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.colors.background03,
      highlightColor: AppTheme.colors.background02,
      child: Card(
        color: AppTheme.colors.background02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 37,
                  backgroundColor: AppTheme.colors.deactive,
                ),
                const SizedBox(height: 16),
                Container(
                  width: 100,
                  height: 16,
                  color: AppTheme.colors.background03,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 16,
                  color: AppTheme.colors.background03,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
