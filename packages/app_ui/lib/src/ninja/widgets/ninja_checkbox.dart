import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    required this.value,
    super.key,
    this.onChanged,
    this.indeterminate = false,
    this.label,
    this.semanticsLabel,
  });

  final bool value;
  final bool indeterminate;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    final filled = value || indeterminate;
    final label = this.label;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    final border = !enabled
        ? colors.surface2
        : filled
            ? colors.accent
            : colors.muted2;

    return AppPressState(
      onTap: enabled ? () => onChanged(!value) : null,
      enabled: enabled,
      semanticsLabel: semanticsLabel ?? label,
      semanticsButton: false,
      semanticsChecked: value,
      semanticsMixed: indeterminate,
      builder: (context, {required pressed}) => ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppControlSize.touchTarget,
          minHeight: AppControlSize.touchTarget,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: label == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              width: AppControlSize.checkbox,
              height: AppControlSize.checkbox,
              decoration: BoxDecoration(
                color: filled && enabled ? colors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.checkbox),
                border: Border.all(color: border, width: 2),
              ),
              child: Center(child: _mark(colors)),
            ),
            if (label != null) ...[
              const SizedBox(width: AppSpacing.gap),
              Flexible(
                child: Text(
                  label,
                  style: AppText.label.copyWith(
                    color: enabled ? colors.ink : colors.muted2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _mark(AppColors colors) {
    if (indeterminate) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.onAccent,
          borderRadius: BorderRadius.circular(AppRadius.xxs),
        ),
        child: const SizedBox(width: AppSpacing.gap, height: 2.5),
      );
    }
    if (!value) return const SizedBox.shrink();
    return AppCheckMark(size: AppIconSize.xs, color: colors.onAccent);
  }
}

class NinjaCheckbox extends StatelessWidget {
  const NinjaCheckbox({
    required this.value,
    super.key,
    this.onChanged,
    this.indeterminate = false,
    this.label,
  });

  final bool value;
  final bool indeterminate;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) => AppCheckbox(
        value: value,
        onChanged: onChanged,
        indeterminate: indeterminate,
        label: label,
      );
}

class AppCheckMark extends StatelessWidget {
  const AppCheckMark({
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
      painter: _CheckPainter(color: color, strokeWidth: strokeWidth),
    );
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
  Widget build(BuildContext context) =>
      AppCheckMark(size: size, color: color, strokeWidth: strokeWidth);
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter({required this.color, required this.strokeWidth});

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
      ..moveTo(5 * scale, 12 * scale)
      ..lineTo(9.5 * scale, 16.5 * scale)
      ..lineTo(19 * scale, 7 * scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
