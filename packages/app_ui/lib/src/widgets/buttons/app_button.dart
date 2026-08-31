// Named static builders provide the package's established button API.
// ignore_for_file: prefer_constructors_over_static_methods

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

enum AppButtonSize { small, medium, large }

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
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
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
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
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
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
  }) : variant = AppButtonVariant.secondary;

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
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
  }) : variant = AppButtonVariant.outline;

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
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
  }) : variant = AppButtonVariant.ghost;

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
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.tooltip,
  }) : variant = AppButtonVariant.danger;

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
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final String? tooltip;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final scale = Theme.of(context).scale;
    final style = _AppButtonStyle.resolve(
      context,
      variant,
      enabled: onPressed != null || loading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
    );

    final height = _height(scale);
    final radius = BorderRadius.circular(borderRadius ?? AppRadius.full);
    Widget content = _ButtonContent(
      label: label,
      icon: icon,
      trailingIcon: trailingIcon,
      foregroundColor: style.foregroundColor,
      textStyle: _textStyle(context),
      iconSize: _iconSize(scale),
      expanded: expanded,
    );
    if (loading) {
      content = Stack(
        alignment: Alignment.center,
        children: [
          Opacity(opacity: 0, child: content),
          SizedBox.square(
            dimension: _iconSize(scale) + 2,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: style.foregroundColor,
            ),
          ),
        ],
      );
    }

    Widget button = AppPressable(
      onTap: _enabled ? onPressed : null,
      semanticsLabel: label,
      semanticsButton: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Material(
          color: style.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: style.borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: padding ?? _padding(scale),
            child: Center(child: content),
          ),
        ),
      ),
    );

    if (expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    if (tooltip != null) {
      button = Tooltip(message: tooltip, child: button);
    }

    return button;
  }

  double _height(AppUiScale scale) {
    return switch (size) {
      AppButtonSize.small => scale.size(44),
      AppButtonSize.medium => scale.size(48),
      AppButtonSize.large => scale.size(52),
    };
  }

  double _iconSize(AppUiScale scale) {
    return switch (size) {
      AppButtonSize.small => scale.icon(16),
      AppButtonSize.medium => scale.icon(18),
      AppButtonSize.large => scale.icon(20),
    };
  }

  EdgeInsetsGeometry _padding(AppUiScale scale) {
    return switch (size) {
      AppButtonSize.small => EdgeInsets.symmetric(
          horizontal: scale.space(AppSpacing.md),
          vertical: scale.space(AppSpacing.xs),
        ),
      AppButtonSize.medium => EdgeInsets.symmetric(
          horizontal: scale.space(AppSpacing.lg),
          vertical: scale.space(AppSpacing.sm),
        ),
      AppButtonSize.large => EdgeInsets.symmetric(
          horizontal: scale.space(AppSpacing.xlg),
          vertical: scale.space(AppSpacing.md),
        ),
    };
  }

  TextStyle _textStyle(BuildContext context) {
    final scale = Theme.of(context).scale;
    final base =
        size == AppButtonSize.large ? AppText.buttonLarge : AppText.button;
    return scale.textStyle(base);
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
    this.variant = AppButtonVariant.ghost,
    this.size = AppButtonSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.dot = false,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  final bool dot;

  @override
  Widget build(BuildContext context) {
    final scale = Theme.of(context).scale;
    final style = _AppButtonStyle.resolve(
      context,
      variant,
      enabled: onPressed != null,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
    );
    final dimension = switch (size) {
      AppButtonSize.small => scale.size(44),
      AppButtonSize.medium => scale.size(48),
      AppButtonSize.large => scale.size(48),
    };
    final iconSize = switch (size) {
      AppButtonSize.small => scale.icon(16),
      AppButtonSize.medium => scale.icon(20),
      AppButtonSize.large => scale.icon(24),
    };
    final button = AppPressable(
      pressedScale: 0.92,
      onTap: onPressed,
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: IconTheme.merge(
          data: IconThemeData(color: style.foregroundColor, size: iconSize),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              style.foregroundColor,
              BlendMode.srcIn,
            ),
            child: icon,
          ),
        ),
        style: IconButton.styleFrom(
          fixedSize: Size.square(dimension),
          minimumSize: Size.square(dimension),
          padding: EdgeInsets.zero,
          backgroundColor: style.backgroundColor,
          foregroundColor: style.foregroundColor,
          disabledBackgroundColor: style.backgroundColor,
          disabledForegroundColor: style.foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimension / 2),
            side: BorderSide(color: style.borderColor),
          ),
        ),
      ),
    );

    if (!dot) return button;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        button,
        Positioned(
          top: 8,
          right: 8,
          child: IgnorePointer(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.foregroundColor,
    required this.textStyle,
    required this.iconSize,
    required this.expanded,
    this.icon,
    this.trailingIcon,
  });

  final String label;
  final Widget? icon;
  final Widget? trailingIcon;
  final Color foregroundColor;
  final TextStyle textStyle;
  final double iconSize;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: textStyle.copyWith(color: foregroundColor),
    );
    final children = [
      if (icon != null) ...[
        _TintedIcon(
          color: foregroundColor,
          size: iconSize,
          child: icon!,
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
      if (expanded) Flexible(child: labelWidget) else labelWidget,
      if (trailingIcon != null) ...[
        const SizedBox(width: AppSpacing.sm),
        _TintedIcon(
          color: foregroundColor,
          size: iconSize,
          child: trailingIcon!,
        ),
      ],
    ];

    return Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class _TintedIcon extends StatelessWidget {
  const _TintedIcon({
    required this.color,
    required this.size,
    required this.child,
  });

  final Color color;
  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: IconThemeData(color: color, size: size),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: child,
      ),
    );
  }
}

class _AppButtonStyle {
  const _AppButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  static _AppButtonStyle resolve(
    BuildContext context,
    AppButtonVariant variant, {
    required bool enabled,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
  }) {
    final colors = Theme.of(context).colors;

    final resolved = switch (variant) {
      AppButtonVariant.primary => _AppButtonStyle(
          backgroundColor: colors.primary,
          foregroundColor: colors.onAccent,
          borderColor: Colors.transparent,
        ),
      AppButtonVariant.secondary => _AppButtonStyle(
          backgroundColor: colors.surfaceHigh,
          foregroundColor: colors.active,
          borderColor: Colors.transparent,
        ),
      AppButtonVariant.outline => _AppButtonStyle(
          backgroundColor: colors.surfaceHigh,
          foregroundColor: colors.active,
          borderColor: Colors.transparent,
        ),
      AppButtonVariant.ghost => _AppButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: colors.active,
          borderColor: Colors.transparent,
        ),
      AppButtonVariant.danger => _AppButtonStyle(
          backgroundColor: colors.error,
          foregroundColor: colors.white,
          borderColor: Colors.transparent,
        ),
    };

    if (!enabled) {
      return _AppButtonStyle(
        backgroundColor: colors.surfaceLow,
        foregroundColor: colors.deactive,
        borderColor: variant == AppButtonVariant.outline
            ? colors.borderLight
            : Colors.transparent,
      );
    }

    return _AppButtonStyle(
      backgroundColor: backgroundColor ?? resolved.backgroundColor,
      foregroundColor: foregroundColor ?? resolved.foregroundColor,
      borderColor: borderColor ?? resolved.borderColor,
    );
  }
}
