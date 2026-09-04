import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';

const double _trackHeight = 4;
const double _thumbSize = 22;
const double _thumbRingWidth = 2;
const double _tickDiameter = 2;
const double _labelReserve = 30;

class AppSlider extends StatefulWidget {
  const AppSlider({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    this.onChangeEnd,
    this.enabled = true,
    this.semanticsLabel,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final ValueChanged<double>? onChangeEnd;
  final bool enabled;
  final String? semanticsLabel;

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  bool _dragging = false;

  bool get _interactive => widget.enabled && widget.onChanged != null;

  double get _range => widget.max - widget.min;

  double get _stepSize {
    final divisions = widget.divisions;
    if (divisions != null && divisions > 0) return _range / divisions;
    return _range / 20;
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  double _valueFromFraction(double fraction) {
    final clamped = fraction.clamp(0.0, 1.0);
    var value = widget.min + clamped * _range;
    final divisions = widget.divisions;
    if (divisions != null && divisions > 0 && _range > 0) {
      final step = _range / divisions;
      value = widget.min + ((value - widget.min) / step).round() * step;
    }
    return value.clamp(widget.min, widget.max);
  }

  void _updateFromDx(double dx, double width) {
    if (width <= 0) return;
    final fraction = (dx / width).clamp(0.0, 1.0);
    final value = _valueFromFraction(fraction);
    if (value != widget.value) widget.onChanged?.call(value);
  }

  void _step(int direction) {
    final next = (widget.value + direction * _stepSize).clamp(
      widget.min,
      widget.max,
    );
    if (next == widget.value) return;
    widget.onChanged?.call(next);
    widget.onChangeEnd?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final interactive = _interactive;
    final label = widget.label;
    final hasLabel = label != null;
    final fraction = _range <= 0
        ? 0.0
        : ((widget.value - widget.min) / _range).clamp(0.0, 1.0);

    return Semantics(
      slider: true,
      label: widget.semanticsLabel,
      value: _formatValue(widget.value),
      increasedValue: _formatValue(
        (widget.value + _stepSize).clamp(widget.min, widget.max),
      ),
      decreasedValue: _formatValue(
        (widget.value - _stepSize).clamp(widget.min, widget.max),
      ),
      enabled: widget.enabled,
      onIncrease:
          interactive && widget.value < widget.max ? () => _step(1) : null,
      onDecrease:
          interactive && widget.value > widget.min ? () => _step(-1) : null,
      child: ExcludeSemantics(
        child: Opacity(
          opacity: widget.enabled ? 1 : 0.4,
          child: SizedBox(
            height: hasLabel
                ? AppControlSize.touchTarget + _labelReserve
                : AppControlSize.touchTarget,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final maxLeft =
                    width - _thumbSize < 0 ? 0.0 : width - _thumbSize;
                final thumbLeft = (fraction * width - _thumbSize / 2).clamp(
                  0.0,
                  maxLeft,
                );
                final trackTop = hasLabel ? _labelReserve : 0.0;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: interactive
                      ? (details) =>
                          _updateFromDx(details.localPosition.dx, width)
                      : null,
                  onTapUp: interactive
                      ? (_) => widget.onChangeEnd?.call(widget.value)
                      : null,
                  onHorizontalDragStart: interactive
                      ? (details) {
                          setState(() => _dragging = true);
                          _updateFromDx(details.localPosition.dx, width);
                        }
                      : null,
                  onHorizontalDragUpdate: interactive
                      ? (details) =>
                          _updateFromDx(details.localPosition.dx, width)
                      : null,
                  onHorizontalDragEnd: interactive
                      ? (_) {
                          setState(() => _dragging = false);
                          widget.onChangeEnd?.call(widget.value);
                        }
                      : null,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: trackTop,
                        height: AppControlSize.touchTarget,
                        child: Center(
                          child: CustomPaint(
                            size: Size(width, _trackHeight),
                            painter: _SliderTrackPainter(
                              fraction: fraction,
                              divisions: widget.divisions,
                              trackColor: colors.surface2,
                              activeColor: colors.accent,
                              tickColor: colors.muted2,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: thumbLeft,
                        top: trackTop +
                            (AppControlSize.touchTarget - _thumbSize) / 2,
                        child: _Thumb(
                          color: colors.surface,
                          ringColor: colors.accent,
                        ),
                      ),
                      if (hasLabel)
                        Positioned(
                          left: thumbLeft + _thumbSize / 2,
                          top: 0,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, 0),
                            child: AnimatedOpacity(
                              duration: reduceMotion
                                  ? Duration.zero
                                  : const Duration(milliseconds: 120),
                              opacity: _dragging ? 1 : 0,
                              child: _LabelBubble(text: label),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.color, required this.ringColor});

  final Color color;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _thumbSize,
      height: _thumbSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: _thumbRingWidth),
      ),
    );
  }
}

class _LabelBubble extends StatelessWidget {
  const _LabelBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.ink,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: AppText.captionSmall.copyWith(color: colors.canvas),
      ),
    );
  }
}

class _SliderTrackPainter extends CustomPainter {
  const _SliderTrackPainter({
    required this.fraction,
    required this.divisions,
    required this.trackColor,
    required this.activeColor,
    required this.tickColor,
  });

  final double fraction;
  final int? divisions;
  final Color trackColor;
  final Color activeColor;
  final Color tickColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, radius),
      Paint()..color = trackColor,
    );
    final activeWidth = size.width * fraction;
    if (activeWidth > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, activeWidth, size.height),
          radius,
        ),
        Paint()..color = activeColor,
      );
    }
    final divisions = this.divisions;
    if (divisions != null && divisions > 0 && size.width > 0) {
      final tickPaint = Paint()..color = tickColor;
      for (var i = 0; i <= divisions; i++) {
        final x = (size.width * i / divisions).clamp(0.0, size.width);
        canvas.drawCircle(
          Offset(x, size.height / 2),
          _tickDiameter / 2,
          tickPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SliderTrackPainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
      oldDelegate.divisions != divisions ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.tickColor != tickColor;
}
