import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:flutter/material.dart';

class NinjaCheckbox extends StatelessWidget {
  const NinjaCheckbox({
    required this.value,
    super.key,
    this.onChanged,
    this.indeterminate = false,
  });
  final bool value;
  final bool indeterminate;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    final filled = value || indeterminate;

    return Semantics(
      checked: value,
      mixed: indeterminate,
      enabled: enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged(!value) : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: filled ? colors.ink : Colors.transparent,
              borderRadius: BorderRadius.circular(7),
              border: filled
                  ? null
                  : Border.all(
                      color: colors.disabledLine,
                    ),
            ),
            child: SizedBox.square(
              dimension: 24,
              child: Center(child: _mark(colors)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mark(NinjaColors colors) {
    if (indeterminate) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.onInk,
          borderRadius: BorderRadius.circular(2),
        ),
        child: const SizedBox(width: 11, height: 3),
      );
    }
    if (!value) return const SizedBox.shrink();
    return NinjaCheckMark(size: 14, color: colors.onInk);
  }
}

class NinjaCheckMark extends StatelessWidget {
  const NinjaCheckMark({
    required this.size,
    required this.color,
    super.key,
    this.strokeWidth = 3,
  });
  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _NinjaCheckPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _NinjaCheckPainter extends CustomPainter {
  const _NinjaCheckPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(4.5 * scale, 12.5 * scale)
      ..lineTo(9.5 * scale, 17.5 * scale)
      ..lineTo(19.5 * scale, 6.5 * scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_NinjaCheckPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
