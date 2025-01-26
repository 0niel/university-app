import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).extension<AppColors>()!.background03,
        highlightColor: Theme.of(context).extension<AppColors>()!.background03.withOpacity(0.5),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).extension<AppColors>()!.background03,
        ),
      ),
    );
  }
}
