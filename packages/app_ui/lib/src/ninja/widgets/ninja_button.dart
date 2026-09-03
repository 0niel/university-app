import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_fab.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:app_ui/src/widgets/app_tooltip.dart';
import 'package:app_ui/src/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

enum NinjaButtonVariant {
  primary,
  secondary,
  tonal,
  outline,
  text,
  destructive,
  destructiveOutline,
}

enum NinjaButtonSize { small, medium, large, hero, standard }

extension NinjaButtonSizeX on NinjaButtonSize {
  AppButtonSize get app => switch (this) {
        NinjaButtonSize.small => AppButtonSize.small,
        NinjaButtonSize.medium => AppButtonSize.medium,
        NinjaButtonSize.standard => AppButtonSize.medium,
        NinjaButtonSize.large => AppButtonSize.large,
        NinjaButtonSize.hero => AppButtonSize.hero,
      };

  double get height => app.height;
}

extension NinjaButtonVariantX on NinjaButtonVariant {
  AppButtonVariant get app => switch (this) {
        NinjaButtonVariant.primary => AppButtonVariant.primary,
        NinjaButtonVariant.secondary => AppButtonVariant.secondary,
        NinjaButtonVariant.outline => AppButtonVariant.secondary,
        NinjaButtonVariant.tonal => AppButtonVariant.tonal,
        NinjaButtonVariant.text => AppButtonVariant.text,
        NinjaButtonVariant.destructive => AppButtonVariant.destructive,
        NinjaButtonVariant.destructiveOutline =>
          AppButtonVariant.destructiveOutline,
      };
}

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

  const NinjaButton.tonal({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.size = NinjaButtonSize.standard,
    this.expanded = false,
    this.loading = false,
  }) : variant = NinjaButtonVariant.tonal;

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
    return AppButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      variant: variant.app,
      size: size.app,
      expanded: expanded,
      loading: loading,
    );
  }
}

enum NinjaIconButtonVariant { outline, filled, surface, tonal, plain }

extension NinjaIconButtonVariantX on NinjaIconButtonVariant {
  AppIconButtonTone get tone => switch (this) {
        NinjaIconButtonVariant.outline => AppIconButtonTone.secondary,
        NinjaIconButtonVariant.filled => AppIconButtonTone.primary,
        NinjaIconButtonVariant.surface => AppIconButtonTone.surface,
        NinjaIconButtonVariant.tonal => AppIconButtonTone.tonal,
        NinjaIconButtonVariant.plain => AppIconButtonTone.plain,
      };
}

class NinjaIconButton extends StatelessWidget {
  const NinjaIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.variant = NinjaIconButtonVariant.outline,
    this.shape = AppIconButtonShape.rounded,
    this.size = AppIconButtonSize.regular,
    this.tooltip,
    this.dot = false,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final NinjaIconButtonVariant variant;
  final AppIconButtonShape shape;
  final AppIconButtonSize size;
  final String? tooltip;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      tone: variant.tone,
      shape: shape,
      size: size,
      dot: dot,
    );
  }
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
    final lineIcon = icon;
    if (lineIcon is AppLineIconWidget) {
      return AppFab(
        icon: lineIcon.icon,
        onPressed: onPressed,
        tooltip: tooltip,
      );
    }
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final enabled = onPressed != null;
    final background = enabled ? colors.accent : colors.canvas;
    final foreground = enabled ? colors.onAccent : colors.muted2;

    Widget fab = AppPressState(
      onTap: onPressed,
      enabled: enabled,
      pressedScale: 0.95,
      semanticsLabel: tooltip,
      semanticsButton: true,
      builder: (context, {required pressed}) => AnimatedContainer(
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        width: AppControlSize.fab,
        height: AppControlSize.fab,
        decoration: BoxDecoration(
          color: pressed ? background.withValues(alpha: .82) : background,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: IconTheme.merge(
            data: IconThemeData(color: foreground, size: AppIconSize.lg),
            child: icon,
          ),
        ),
      ),
    );

    if (tooltip != null) fab = AppTooltipAnchor(message: tooltip!, child: fab);
    return fab;
  }
}

class NinjaSplitButton extends StatelessWidget {
  const NinjaSplitButton({
    required this.label,
    super.key,
    this.onPressed,
    this.onMenuPressed,
    this.menuIcon = AppLineIcon.chevronD,
  });

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onMenuPressed;
  final AppLineIcon menuIcon;

  @override
  Widget build(BuildContext context) {
    return AppSplitButton(
      label: label,
      onPressed: onPressed,
      onMenuPressed: onMenuPressed,
      menuIcon: menuIcon,
    );
  }
}
