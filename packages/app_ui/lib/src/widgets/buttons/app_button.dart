import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:app_ui/src/widgets/app_tooltip.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant {
  primary,
  secondary,
  tonal,
  text,
  destructive,
  destructiveOutline,
  outline,
  ghost,
  danger,
}

enum AppButtonSize { small, medium, large, hero }

abstract final class _ButtonMetrics {
  static const double leadingPadding = AppSpacing.lg;
  static const double trailingPadding = 18;
  static const double iconGap = AppSpacing.sm;
  static const double iconStroke = 2.4;
  static const double smallIcon = 15;
  static const double largeIcon = 18;
  static const double compactIcon = 17;
  static const double spinnerStroke = 2.5;
  static const double dotSize = 7;
  static const double dotInset = 9;
}

extension AppButtonSizeX on AppButtonSize {
  double get height => switch (this) {
        AppButtonSize.small => AppControlSize.buttonSmall,
        AppButtonSize.medium => AppControlSize.buttonMedium,
        AppButtonSize.large => AppControlSize.buttonLarge,
        AppButtonSize.hero => AppControlSize.buttonHero,
      };

  double get horizontalPadding => switch (this) {
        AppButtonSize.small => AppSpacing.lg,
        AppButtonSize.medium => AppSpacing.xl,
        AppButtonSize.large => AppSpacing.section,
        AppButtonSize.hero => AppSpacing.section,
      };

  TextStyle get textStyle => switch (this) {
        AppButtonSize.small => AppText.buttonSmall,
        AppButtonSize.medium => AppText.button,
        AppButtonSize.large =>
          AppText.buttonLarge.copyWith(fontWeight: FontWeight.w600),
        AppButtonSize.hero => AppText.buttonHero,
      };

  double get iconSize => switch (this) {
        AppButtonSize.small => _ButtonMetrics.smallIcon,
        AppButtonSize.medium => AppIconSize.sm,
        AppButtonSize.large => _ButtonMetrics.largeIcon,
        AppButtonSize.hero => AppIconSize.md,
      };
}

class AppButtonPalette {
  const AppButtonPalette({
    required this.background,
    required this.pressed,
    required this.foreground,
    required this.spinnerTrack,
    this.pressedOpacity = 1,
  });

  factory AppButtonPalette.of(
    AppColors colors,
    AppButtonVariant variant, {
    required bool enabled,
  }) {
    if (!enabled) {
      return AppButtonPalette(
        background: colors.canvas,
        pressed: colors.canvas,
        foreground: colors.muted2,
        spinnerTrack: colors.line,
      );
    }
    return switch (variant) {
      AppButtonVariant.primary => AppButtonPalette(
          background: colors.accent,
          pressed: colors.accent,
          foreground: colors.onAccent,
          spinnerTrack: colors.white.withValues(alpha: .35),
          pressedOpacity: .82,
        ),
      AppButtonVariant.secondary ||
      AppButtonVariant.outline =>
        AppButtonPalette(
          background: colors.surface2,
          pressed: colors.canvas,
          foreground: colors.ink,
          spinnerTrack: colors.line,
        ),
      AppButtonVariant.tonal => AppButtonPalette(
          background: colors.tint,
          pressed: colors.canvas,
          foreground: colors.accent,
          spinnerTrack: colors.line,
        ),
      AppButtonVariant.text || AppButtonVariant.ghost => AppButtonPalette(
          background: Colors.transparent,
          pressed: colors.canvas,
          foreground: colors.accent,
          spinnerTrack: colors.line,
        ),
      AppButtonVariant.destructive ||
      AppButtonVariant.danger =>
        AppButtonPalette(
          background: colors.danger,
          pressed: colors.danger,
          foreground: colors.white,
          spinnerTrack: colors.white.withValues(alpha: .35),
          pressedOpacity: .82,
        ),
      AppButtonVariant.destructiveOutline => AppButtonPalette(
          background: colors.examTint,
          pressed: colors.canvas,
          foreground: colors.danger,
          spinnerTrack: colors.line,
        ),
    };
  }

  final Color background;
  final Color pressed;
  final Color foreground;
  final Color spinnerTrack;
  final double pressedOpacity;
}

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  });

  const AppButton.primary({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.tonal({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  }) : variant = AppButtonVariant.tonal;

  const AppButton.outline({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  }) : variant = AppButtonVariant.text;

  const AppButton.text({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  }) : variant = AppButtonVariant.text;

  const AppButton.danger({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  }) : variant = AppButtonVariant.destructive;

  const AppButton.destructive({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  }) : variant = AppButtonVariant.destructive;

  const AppButton.destructiveOutline({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
    this.textStyle,
  }) : variant = AppButtonVariant.destructiveOutline;

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? trailingIcon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool expanded;
  final bool loading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final String? tooltip;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null && !loading;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final palette = AppButtonPalette.of(
      colors,
      variant,
      enabled: onPressed != null || loading,
    );
    final background = backgroundColor ?? palette.background;
    final foreground = foregroundColor ?? palette.foreground;
    final radius = BorderRadius.circular(borderRadius ?? AppRadius.full);
    final hasLeading = icon != null || loading;
    final resolvedPadding = padding ??
        EdgeInsets.only(
          left: hasLeading && size == AppButtonSize.medium
              ? _ButtonMetrics.leadingPadding
              : size.horizontalPadding,
          right: hasLeading && size == AppButtonSize.medium
              ? _ButtonMetrics.trailingPadding
              : size.horizontalPadding,
        );

    Widget button = AppPressState(
      onTap: enabled ? onPressed : null,
      enabled: enabled,
      semanticsLabel: label,
      semanticsButton: true,
      builder: (context, {required pressed}) => AnimatedOpacity(
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        opacity: pressed ? palette.pressedOpacity : 1,
        child: AnimatedContainer(
          duration:
              reduceMotion ? Duration.zero : const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          height: size.height,
          padding: resolvedPadding,
          decoration: BoxDecoration(
            color: pressed ? (backgroundColor ?? palette.pressed) : background,
            borderRadius: radius,
          ),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading) ...[
                AppButtonSpinner(
                  color: foreground,
                  trackColor: palette.spinnerTrack,
                ),
                const SizedBox(width: _ButtonMetrics.iconGap),
              ] else if (icon != null) ...[
                _ButtonIcon(
                  color: foreground,
                  size: size.iconSize,
                  strokeWidth: _ButtonMetrics.iconStroke,
                  child: icon!,
                ),
                const SizedBox(width: _ButtonMetrics.iconGap),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: size.textStyle
                      .merge(textStyle)
                      .copyWith(color: foreground),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: _ButtonMetrics.iconGap),
                _ButtonIcon(
                  color: foreground,
                  size: size.iconSize,
                  strokeWidth: _ButtonMetrics.iconStroke,
                  child: trailingIcon!,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (expanded) button = SizedBox(width: double.infinity, child: button);
    if (tooltip != null) {
      button = AppTooltipAnchor(message: tooltip!, child: button);
    }
    return button;
  }
}

class AppButtonSpinner extends StatefulWidget {
  const AppButtonSpinner({
    required this.color,
    required this.trackColor,
    super.key,
    this.size = AppIconSize.sm,
    this.strokeWidth = _ButtonMetrics.spinnerStroke,
  });

  final Color color;
  final Color trackColor;
  final double size;
  final double strokeWidth;

  @override
  State<AppButtonSpinner> createState() => _AppButtonSpinnerState();
}

class _AppButtonSpinnerState extends State<AppButtonSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate = !MediaQuery.disableAnimationsOf(context) &&
        !MediaQuery.accessibleNavigationOf(context) &&
        TickerMode.valuesOf(context).enabled;
    if (animate && !_controller.isAnimating) {
      unawaited(_controller.repeat());
    } else if (!animate) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _RingSpinnerPainter(
            turns: _controller.value,
            color: widget.color,
            trackColor: widget.trackColor,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _RingSpinnerPainter extends CustomPainter {
  const _RingSpinnerPainter({
    required this.turns,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double turns;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arc = rect.deflate(strokeWidth / 2);
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final head = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas
      ..drawOval(arc, track)
      ..drawArc(
        arc,
        -math.pi / 2 + turns * 2 * math.pi,
        math.pi / 2,
        false,
        head,
      );
  }

  @override
  bool shouldRepaint(_RingSpinnerPainter oldDelegate) =>
      oldDelegate.turns != turns ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}

class _ButtonIcon extends StatelessWidget {
  const _ButtonIcon({
    required this.color,
    required this.size,
    required this.child,
    this.strokeWidth,
  });

  final Color color;
  final double size;
  final Widget child;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final lineIcon = child;
    if (lineIcon is AppLineIconWidget) {
      return AppLineIconWidget(
        lineIcon.icon,
        size: size,
        color: color,
        strokeWidth: strokeWidth ?? lineIcon.strokeWidth,
      );
    }
    return IconTheme.merge(
      data: IconThemeData(color: color, size: size),
      child: child,
    );
  }
}

enum AppIconButtonTone { secondary, primary, surface, tonal, danger, plain }

enum AppIconButtonShape { rounded, circle }

enum AppIconButtonSize { regular, compact, small }

extension AppIconButtonSizeX on AppIconButtonSize {
  double get dimension => switch (this) {
        AppIconButtonSize.regular => AppControlSize.iconButton,
        AppIconButtonSize.compact => AppControlSize.iconButtonCompact,
        AppIconButtonSize.small => AppControlSize.iconButtonSmall,
      };

  double get iconSize => switch (this) {
        AppIconButtonSize.regular => AppIconSize.md,
        AppIconButtonSize.compact => AppIconSize.md,
        AppIconButtonSize.small => _ButtonMetrics.compactIcon,
      };
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
    this.tone = AppIconButtonTone.secondary,
    this.shape = AppIconButtonShape.rounded,
    this.size = AppIconButtonSize.regular,
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.strokeWidth,
    this.dot = false,
    this.dotColor,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final AppIconButtonTone tone;
  final AppIconButtonShape shape;
  final AppIconButtonSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? iconSize;
  final double? strokeWidth;
  final bool dot;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;
    final palette = switch (tone) {
      AppIconButtonTone.primary => (
          colors.accent,
          colors.accent.withValues(alpha: .82),
          colors.onAccent,
        ),
      AppIconButtonTone.surface => (
          colors.surface,
          colors.canvas,
          colors.ink,
        ),
      AppIconButtonTone.tonal => (colors.tint, colors.canvas, colors.accent),
      AppIconButtonTone.danger => (
          colors.examTint,
          colors.canvas,
          colors.danger,
        ),
      AppIconButtonTone.plain => (
          Colors.transparent,
          colors.canvas,
          colors.ink,
        ),
      AppIconButtonTone.secondary => (
          colors.surface2,
          colors.canvas,
          colors.ink,
        ),
    };
    final (background, pressedBackground, foreground) =
        enabled ? palette : (colors.canvas, colors.canvas, colors.muted2);
    final dimension = size.dimension;
    final target = math.max(dimension, AppControlSize.touchTarget);
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    Widget button = AppPressState(
      onTap: onPressed,
      enabled: enabled,
      pressedScale: 0.94,
      semanticsLabel: tooltip,
      semanticsButton: true,
      builder: (context, {required pressed}) => SizedBox.square(
        dimension: target,
        child: Center(
          child: AnimatedContainer(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            width: dimension,
            height: dimension,
            decoration: BoxDecoration(
              color: pressed
                  ? (backgroundColor ?? pressedBackground)
                  : (backgroundColor ?? background),
              borderRadius: shape == AppIconButtonShape.rounded
                  ? BorderRadius.circular(AppRadius.field)
                  : BorderRadius.circular(dimension / 2),
            ),
            child: Center(
              child: _ButtonIcon(
                color: foregroundColor ?? foreground,
                size: iconSize ?? size.iconSize,
                strokeWidth: strokeWidth ??
                    (tone == AppIconButtonTone.primary ? 2.2 : 2),
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );

    if (dot) {
      button = Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            top: _ButtonMetrics.dotInset,
            right: _ButtonMetrics.dotInset,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: dotColor ?? colors.danger,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: _ButtonMetrics.dotSize),
              ),
            ),
          ),
        ],
      );
    }

    if (tooltip != null) {
      button = AppTooltipAnchor(message: tooltip!, child: button);
    }
    return button;
  }
}

class AppSplitButton extends StatelessWidget {
  const AppSplitButton({
    required this.label,
    super.key,
    this.onPressed,
    this.onMenuPressed,
    this.menuIcon = AppLineIcon.chevronD,
    this.size = AppButtonSize.medium,
    this.menuSemanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onMenuPressed;
  final AppLineIcon menuIcon;
  final AppButtonSize size;
  final String? menuSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null || onMenuPressed != null;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final background = enabled ? colors.accent : colors.canvas;
    final foreground = enabled ? colors.onAccent : colors.muted2;
    final trailingBackground = enabled ? colors.accentPressed : colors.canvas;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: SizedBox(
        height: size.height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: AppPressState(
                onTap: onPressed,
                enabled: onPressed != null,
                semanticsLabel: label,
                semanticsButton: true,
                builder: (context, {required pressed}) => AnimatedContainer(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  height: size.height,
                  padding: const EdgeInsets.symmetric(
                    horizontal: _ButtonMetrics.trailingPadding,
                  ),
                  color:
                      pressed ? background.withValues(alpha: .82) : background,
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: size.textStyle.copyWith(color: foreground),
                  ),
                ),
              ),
            ),
            AppPressState(
              onTap: onMenuPressed,
              enabled: onMenuPressed != null,
              semanticsButton: true,
              semanticsLabel: menuSemanticLabel ??
                  MaterialLocalizations.of(context).moreButtonTooltip,
              builder: (context, {required pressed}) => AnimatedContainer(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                width: AppControlSize.touchTarget,
                height: size.height,
                color: pressed
                    ? trailingBackground.withValues(alpha: .82)
                    : trailingBackground,
                child: Center(
                  child: AppLineIconWidget(
                    menuIcon,
                    size: AppIconSize.sm,
                    color: foreground,
                    strokeWidth: _ButtonMetrics.iconStroke,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
