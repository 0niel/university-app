import 'package:app_ui/src/widgets/app_progress_ring.dart';
import 'package:flutter/widgets.dart';

class NinjaProgressRing extends StatelessWidget {
  const NinjaProgressRing({
    required this.value,
    super.key,
    this.size = 64,
    this.holeSize = 52,
    this.strokeWidth = 6,
    this.label,
    this.color,
    this.labelStyle,
  });

  final double value;
  final double size;
  final double holeSize;
  final double strokeWidth;
  final String? label;
  final Color? color;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0);
    return AppProgressRing(
      value: progress,
      size: size,
      strokeWidth: strokeWidth,
      color: color,
      label: label ?? '${(progress * 100).round()}%',
      labelStyle: labelStyle,
    );
  }
}
