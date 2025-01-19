import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
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
        baseColor: AppTheme.colorsOf(context).background03,
        highlightColor: AppTheme.colorsOf(context).background03.withOpacity(0.5),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: AppTheme.colorsOf(context).background03,
        ),
      ),
    );
  }
}
