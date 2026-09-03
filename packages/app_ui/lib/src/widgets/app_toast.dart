import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppToast extends StatelessWidget {
  const AppToast({
    required this.message,
    super.key,
    this.icon,
    this.showIcon = true,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.leading,
  });

  final String message;
  final AppLineIcon? icon;
  final bool showIcon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final action = actionLabel;
    final leading = this.leading;
    final stacked = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final messageWidget = Semantics(
      liveRegion: true,
      child: Row(
        children: [
          if (leading != null) ...[
            leading,
            const SizedBox(width: AppSpacing.md),
          ] else if (showIcon) ...[
            AppIconTile(
              icon: icon ?? AppLineIcon.check,
              size: 32,
              radius: AppRadius.sm,
              background: iconColor ?? colors.accent,
              foreground: colors.onAccent,
              iconSize: AppIconSize.action,
              strokeWidth: 2.5,
            ),
            const SizedBox(width: AppSpacing.md),
          ] else
            const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: AppText.compact.copyWith(color: colors.canvas),
            ),
          ),
        ],
      ),
    );
    final actionWidget = action == null
        ? null
        : AppPressable(
            onTap: onAction,
            semanticsLabel: action,
            semanticsButton: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              child: Container(
                constraints: const BoxConstraints(minHeight: 40, minWidth: 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sectionGap,
                  vertical: AppSpacing.xsm,
                ),
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                ),
                child: Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Text(
                    action,
                    textAlign: TextAlign.center,
                    style: AppText.label.copyWith(color: colors.onAccent),
                  ),
                ),
              ),
            ),
          );
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: actionWidget == null ? AppSpacing.md : AppSpacing.gap,
      ),
      decoration: BoxDecoration(
        color: colors.ink,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => stacked && actionWidget != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  messageWidget,
                  const SizedBox(height: AppSpacing.sm),
                  actionWidget,
                ],
              )
            : Row(
                children: [
                  Expanded(child: messageWidget),
                  if (actionWidget != null) ...[
                    const SizedBox(width: AppSpacing.md),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * .45,
                      ),
                      child: actionWidget,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
