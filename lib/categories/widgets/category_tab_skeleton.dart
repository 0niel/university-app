import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CategoryTabSkeleton extends StatelessWidget {
  const CategoryTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 96,
      height: NinjaMetrics.minTouchTarget,
      child: Center(
        child: NinjaSkeleton(
          width: 96,
          height: NinjaMetrics.minTouchTarget,
          radius: NinjaRadius.pill,
        ),
      ),
    );
  }
}
