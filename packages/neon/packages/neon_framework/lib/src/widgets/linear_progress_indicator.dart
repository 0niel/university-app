import 'package:flutter/material.dart';

/// Wrapped [LinearProgressIndicator].
///
/// Adds default styling to the [LinearProgressIndicator].
class NeonLinearProgressIndicator extends StatelessWidget {
  /// Creates a new Neon styled [LinearProgressIndicator].
  const NeonLinearProgressIndicator({
    this.visible = true,
    this.margin = const EdgeInsets.symmetric(horizontal: 10),
    this.color,
    this.backgroundColor = Colors.transparent,
    super.key,
  });

  /// Whether the indicator is visible.
  final bool visible;

  /// Empty space to surround the indicator.
  final EdgeInsets? margin;

  /// {@macro flutter.progress_indicator.ProgressIndicator.color}
  final Color? color;

  /// {@macro flutter.material.LinearProgressIndicator.trackColor}
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        constraints: BoxConstraints.tight(const Size.fromHeight(3)),
        child: visible
            ? LinearProgressIndicator(
                color: color,
                backgroundColor: backgroundColor,
              )
            : null,
      );
}
