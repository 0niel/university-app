import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/gestures.dart' show kTouchSlop;
import 'package:flutter/material.dart';

class NinjaButton extends StatelessWidget {
  const NinjaButton({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.variant = NinjaButtonVariant.primary,
    this.size = NinjaButtonSize.standard,
    this.expanded = false,
    this.loading = false,
  });
  const NinjaButton.primary({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.size = NinjaButtonSize.standard,
    this.expanded = false,
    this.loading = false,
  }) : variant = NinjaButtonVariant.primary;
  const NinjaButton.secondary({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.size = NinjaButtonSize.standard,
    this.expanded = false,
    this.loading = false,
  }) : variant = NinjaButtonVariant.secondary;
  const NinjaButton.outline({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.size = NinjaButtonSize.standard,
    this.expanded = false,
    this.loading = false,
  }) : variant = NinjaButtonVariant.outline;
  const NinjaButton.text({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.size = NinjaButtonSize.standard,
    this.expanded = false,
    this.loading = false,
  }) : variant = NinjaButtonVariant.text;
  const NinjaButton.destructive({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.size = NinjaButtonSize.standard,
    this.expanded = false,
    this.loading = false,
  }) : variant = NinjaButtonVariant.destructive;
  const NinjaButton.destructiveOutline({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.size = NinjaButtonSize.standard,
    this.expanded = false,
    this.loading = false,
  }) : variant = NinjaButtonVariant.destructiveOutline;
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;

  final NinjaButtonVariant variant;
  final NinjaButtonSize size;
  final bool expanded;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final disabled = onPressed == null && !loading;
    final palette = _NinjaButtonPalette.resolve(
      colors,
      variant,
      disabled: disabled,
    );
    final leading =
        loading ? _NinjaButtonSpinner(color: palette.foreground) : icon;

    Widget content = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          IconTheme.merge(
            data: IconThemeData(
              color: palette.foreground,
              size: size.iconSize,
            ),
            child: leading,
          ),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: size.labelStyle.copyWith(color: palette.foreground),
          ),
        ),
      ],
    );

    content = _NinjaPressFill(
      color: palette.background,
      pressedColor: palette.pressed,
      borderRadius: BorderRadius.circular(size.radius),
      enabled: !disabled && !loading,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: size.height),
        child: Padding(
          padding: variant == NinjaButtonVariant.text
              ? size.padding.copyWith(left: 16, right: 16)
              : size.padding,
          child: Center(widthFactor: expanded ? null : 1, child: content),
        ),
      ),
    );

    Widget button = Semantics(
      button: true,
      enabled: !disabled,
      child: AppPressable(onTap: loading ? null : onPressed, child: content),
    );

    if (expanded) button = SizedBox(width: double.infinity, child: button);
    return button;
  }
}

enum NinjaButtonVariant {
  primary,
  secondary,
  outline,
  text,
  destructive,
  destructiveOutline,
}

enum NinjaButtonSize {
  small(
    height: 44,
    radius: NinjaRadius.button,
    iconSize: 14,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
    labelStyle: NinjaText.buttonSmall,
  ),
  medium(
    height: 48,
    radius: NinjaRadius.button,
    iconSize: 16,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    labelStyle: NinjaText.button,
  ),
  large(
    height: 52,
    radius: NinjaRadius.button,
    iconSize: 18,
    padding: EdgeInsets.symmetric(horizontal: 26, vertical: 15),
    labelStyle: NinjaText.buttonLarge,
  ),
  standard(
    height: 48,
    radius: NinjaRadius.button,
    iconSize: 16,
    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    labelStyle: NinjaText.body,
  );

  const NinjaButtonSize({
    required this.height,
    required this.radius,
    required this.iconSize,
    required this.padding,
    required this.labelStyle,
  });
  final double height;
  final double radius;
  final double iconSize;
  final EdgeInsets padding;
  final TextStyle labelStyle;
}

class NinjaIconButton extends StatelessWidget {
  const NinjaIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.variant = NinjaIconButtonVariant.outline,
    this.tooltip,
  });
  final Widget icon;
  final VoidCallback? onPressed;

  final NinjaIconButtonVariant variant;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final disabled = onPressed == null;
    final filled = variant == NinjaIconButtonVariant.filled;
    var background = filled ? colors.brand : colors.surfaceAlt;
    var foreground = filled ? colors.onBrand : colors.ink;
    if (disabled) {
      background = colors.surface;
      foreground = colors.disabled;
    }

    Widget button = Semantics(
      button: true,
      enabled: !disabled,
      label: tooltip,
      child: AppPressable(
        pressedScale: 0.92,
        onTap: onPressed,
        child: _NinjaPressFill(
          color: background,
          pressedColor:
              filled ? colors.brand.withValues(alpha: 0.82) : colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.button),
          enabled: !disabled,
          child: SizedBox.square(
            dimension: NinjaMetrics.minTouchTarget,
            child: Center(
              child: IconTheme.merge(
                data: IconThemeData(color: foreground, size: 20),
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) button = Tooltip(message: tooltip, child: button);
    return button;
  }
}

enum NinjaIconButtonVariant {
  outline,
  filled,
}

class NinjaFab extends StatelessWidget {
  const NinjaFab({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
  });
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final disabled = onPressed == null;

    Widget fab = Semantics(
      button: true,
      enabled: !disabled,
      label: tooltip,
      child: AppPressable(
        pressedScale: 0.95,
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: disabled ? colors.surface : colors.brand,
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: 56,
            child: Center(
              child: IconTheme.merge(
                data: IconThemeData(
                  color: disabled ? colors.disabled : colors.onBrand,
                  size: 24,
                ),
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) fab = Tooltip(message: tooltip, child: fab);
    return fab;
  }
}

class NinjaSplitButton extends StatelessWidget {
  const NinjaSplitButton({
    required this.label,
    super.key,
    this.onPressed,
    this.onMenuPressed,
    this.menuIcon = Icons.keyboard_arrow_down_rounded,
  });
  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onMenuPressed;
  final IconData menuIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final disabled = onPressed == null && onMenuPressed == null;
    final background = disabled ? colors.surface : colors.brand;
    final foreground = disabled ? colors.disabled : colors.onBrand;

    return Semantics(
      button: true,
      enabled: !disabled,
      child: AppPressable(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(NinjaRadius.button),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ColoredBox(
                  color: background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.body.copyWith(color: foreground),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onMenuPressed,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: disabled
                          ? colors.surface
                          : colors.brand.withValues(alpha: 0.82),
                      border: Border(
                        left: BorderSide(
                          color: foreground.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        widthFactor: 1,
                        child: Icon(menuIcon, size: 16, color: foreground),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NinjaButtonSpinner extends StatelessWidget {
  const _NinjaButtonSpinner({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color,
        backgroundColor: color.withValues(alpha: 0.3),
      ),
    );
  }
}

class _NinjaPressFill extends StatefulWidget {
  const _NinjaPressFill({
    required this.color,
    required this.pressedColor,
    required this.borderRadius,
    required this.enabled,
    required this.child,
  });

  final Color color;
  final Color pressedColor;
  final BorderRadius borderRadius;
  final bool enabled;
  final Widget child;

  @override
  State<_NinjaPressFill> createState() => _NinjaPressFillState();
}

class _NinjaPressFillState extends State<_NinjaPressFill> {
  bool _down = false;
  Offset? _origin;

  void _setDown(bool value) {
    if (_down == value) return;
    setState(() => _down = value);
  }

  void _onDown(PointerDownEvent event) {
    _origin = event.position;
    _setDown(true);
  }

  void _onMove(PointerMoveEvent event) {
    final origin = _origin;
    if (origin == null) return;
    if ((event.position - origin).distance > kTouchSlop) _setDown(false);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: enabled ? _onDown : null,
      onPointerMove: enabled ? _onMove : null,
      onPointerUp: enabled ? (_) => _setDown(false) : null,
      onPointerCancel: enabled ? (_) => _setDown(false) : null,
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(
          end: _down && enabled ? widget.pressedColor : widget.color,
        ),
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 90),
        builder: (context, color, child) => DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: widget.borderRadius,
          ),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

class _NinjaButtonPalette {
  const _NinjaButtonPalette({
    required this.background,
    required this.foreground,
    required this.pressed,
  });

  factory _NinjaButtonPalette.resolve(
    NinjaColors colors,
    NinjaButtonVariant variant, {
    required bool disabled,
  }) {
    if (disabled) {
      return _NinjaButtonPalette(
        background: colors.surface,
        foreground: colors.disabled,
        pressed: colors.surface,
      );
    }
    return switch (variant) {
      NinjaButtonVariant.primary => _NinjaButtonPalette(
          background: colors.brand,
          foreground: colors.onBrand,
          pressed: colors.brand.withValues(alpha: 0.82),
        ),
      NinjaButtonVariant.secondary ||
      NinjaButtonVariant.outline =>
        _NinjaButtonPalette(
          background: colors.surfaceAlt,
          foreground: colors.ink,
          pressed: colors.surface,
        ),
      NinjaButtonVariant.text => _NinjaButtonPalette(
          background: Colors.transparent,
          foreground: colors.brandInk,
          pressed: colors.surface,
        ),
      NinjaButtonVariant.destructive => _NinjaButtonPalette(
          background: colors.scarlet,
          foreground: Colors.white,
          pressed:
              Color.lerp(colors.scarlet, colors.ink, 0.12) ?? colors.scarlet,
        ),
      NinjaButtonVariant.destructiveOutline => _NinjaButtonPalette(
          background: colors.dangerTint,
          foreground: colors.scarlet,
          pressed: colors.dangerTint,
        ),
    };
  }

  final Color background;
  final Color foreground;
  final Color pressed;
}
