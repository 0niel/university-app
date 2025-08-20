import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template progress_indicator}
/// A reusable progress indicator of news blocks.
/// {@endtemplate}
class ProgressIndicator extends StatelessWidget {
  /// {@macro progress_indicator}
  const ProgressIndicator({
    super.key,
    this.progress,
    this.color,
  });

  /// The current progress of this indicator (between 0 and 1).
  final double? progress;

  /// The color of this indicator.
  ///
  /// Defaults to [AppColors.gainsboro].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ColoredBox(
      color: color ?? colors.shimmerBase,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            value: progress,
          ),
        ),
      ),
    );
  }
}
