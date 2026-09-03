import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_dashed_border.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

enum AppWeekGridCellVariant { filled, cancelled, busy, empty }

class AppWeekGridCell extends StatelessWidget {
  const AppWeekGridCell({
    super.key,
    this.variant = AppWeekGridCellVariant.filled,
    this.topLabel,
    this.bottomLabel,
    this.tone,
    this.selected = false,
    this.scheduleStyle = false,
    this.onTap,
  });

  static const double height = 54;

  final AppWeekGridCellVariant variant;
  final String? topLabel;
  final String? bottomLabel;
  final Color? tone;
  final bool selected;
  final bool scheduleStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cancelled = variant == AppWeekGridCellVariant.cancelled;
    final empty = variant == AppWeekGridCellVariant.empty;
    final busy = variant == AppWeekGridCellVariant.busy;
    final accent = tone ?? colors.accent;

    final foreground = switch (variant) {
      AppWeekGridCellVariant.filled => accent,
      AppWeekGridCellVariant.cancelled => colors.exam,
      AppWeekGridCellVariant.busy => colors.muted,
      AppWeekGridCellVariant.empty => colors.muted2,
    };
    final background = switch (variant) {
      AppWeekGridCellVariant.filled => colors.tintOf(accent),
      AppWeekGridCellVariant.cancelled => colors.examTint,
      AppWeekGridCellVariant.busy => colors.surface2,
      AppWeekGridCellVariant.empty => colors.surface,
    };
    final radius = BorderRadius.circular(AppRadius.sm);
    final top = cancelled ? (topLabel ?? 'ОТМ') : topLabel;
    final decoration =
        cancelled && !scheduleStyle ? TextDecoration.lineThrough : null;

    Widget content = empty
        ? scheduleStyle
            ? const SizedBox.expand()
            : Center(
                child: AppLineIconWidget(
                  AppLineIcon.plus,
                  size: AppIconSize.xs,
                  color: colors.muted2,
                ),
              )
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: scheduleStyle ? AppSpacing.xsm : AppSpacing.fine,
              vertical: scheduleStyle ? AppSpacing.compactGap : AppSpacing.xsm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (top != null)
                  Text(
                    top,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.gridTag.copyWith(
                      color: scheduleStyle
                          ? foreground.withValues(alpha: .85)
                          : foreground,
                      decoration: decoration,
                      decorationColor: foreground,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                if (bottomLabel != null)
                  Text(
                    bottomLabel!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(10, FontWeight.w700).copyWith(
                      height: scheduleStyle ? 1.1 : null,
                      color: foreground,
                      decoration: decoration,
                      decorationColor: foreground,
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          );

    if (busy && !scheduleStyle) {
      content = Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _HatchPainter(color: colors.line)),
          content,
        ],
      );
    }

    if (selected && !scheduleStyle) {
      content = Stack(
        fit: StackFit.expand,
        children: [
          content,
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(color: colors.accent, width: 2),
              ),
            ),
          ),
        ],
      );
    }

    Widget cell = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        border: scheduleStyle
            ? Border.all(
                color: empty || busy
                    ? colors.line
                    : selected
                        ? colors.accent
                        : foreground.withValues(alpha: 0),
              )
            : null,
      ),
      child: ClipRRect(borderRadius: radius, child: content),
    );

    if (empty && !scheduleStyle) {
      cell = AppDashedBorder(
        color: colors.line,
        radius: AppRadius.sm,
        strokeWidth: 1,
        child: cell,
      );
    }

    return SizedBox(
      height: height,
      child: AppPressable(
        onTap: onTap,
        semanticsLabel: [
          top,
          bottomLabel,
        ].where((value) => value != null).join(' '),
        semanticsSelected: selected,
        child: cell,
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  const _HatchPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final span = size.width + size.height;
    for (var offset = 4 * math.sqrt2; offset < span; offset += 5 * math.sqrt2) {
      canvas.drawPath(
        Path()
          ..moveTo(offset, 0)
          ..lineTo(offset + math.sqrt2, 0)
          ..lineTo(offset + math.sqrt2 - size.height, size.height)
          ..lineTo(offset - size.height, size.height)
          ..close(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_HatchPainter oldDelegate) => oldDelegate.color != color;
}
