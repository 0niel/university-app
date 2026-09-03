import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppHeaderAction {
  const AppHeaderAction({
    this.icon,
    this.child,
    this.onTap,
    this.badge = false,
    this.badgeColor,
    this.semanticsLabel,
  });

  final AppLineIcon? icon;
  final Widget? child;
  final VoidCallback? onTap;
  final bool badge;
  final Color? badgeColor;
  final String? semanticsLabel;
}

class AppHeaderTextAction {
  const AppHeaderTextAction({
    required this.label,
    required this.onTap,
    this.key,
  });

  final String label;
  final VoidCallback? onTap;
  final Key? key;
}

class AppHeaderCircleButton extends StatelessWidget {
  const AppHeaderCircleButton({
    required this.action,
    super.key,
    this.size = AppControlSize.iconButtonCompact,
    this.background,
    this.foreground,
    this.iconSize = AppIconSize.md,
    this.visualAlignment = Alignment.center,
  });

  final AppHeaderAction action;
  final double size;
  final Color? background;
  final Color? foreground;
  final double iconSize;
  final AlignmentGeometry visualAlignment;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = foreground ?? colors.ink;

    return AppPressable(
      onTap: action.onTap,
      enabled: action.onTap != null,
      semanticsLabel: action.semanticsLabel,
      semanticsButton: true,
      child: SizedBox.square(
        dimension: math.max(size, AppControlSize.touchTarget),
        child: Align(
          alignment: visualAlignment,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background ?? colors.surface,
              shape: BoxShape.circle,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                Center(
                  child: action.child ??
                      AppLineIconWidget(
                        action.icon ?? AppLineIcon.more,
                        size: iconSize,
                        color: fg,
                      ),
                ),
                if (action.badge)
                  Positioned(
                    top: size * .18,
                    right: size * .18,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: action.badgeColor ?? colors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox.square(dimension: 7),
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

class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    required this.title,
    super.key,
    this.overline,
    this.subtitle,
    this.actions = const <AppHeaderAction>[],
    this.trailing,
    this.textAction,
    this.padding,
    this.applyTopInset = true,
    this.titleStyle,
  }) : assert(
          trailing == null || textAction == null,
          'Use either trailing or textAction.',
        );

  final String title;
  final String? overline;
  final String? subtitle;
  final List<AppHeaderAction> actions;
  final Widget? trailing;
  final AppHeaderTextAction? textAction;
  final EdgeInsetsGeometry? padding;
  final bool applyTopInset;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final top = applyTopInset
        ? math.max(
            AppSpacing.screenTop,
            MediaQuery.paddingOf(context).top + AppSpacing.md,
          )
        : 0.0;

    final overline = this.overline;
    final subtitle = this.subtitle;
    final insets = (padding ??
            EdgeInsets.fromLTRB(
              AppSpacing.screen,
              top,
              AppSpacing.screen,
              AppSpacing.zero,
            ))
        .resolve(Directionality.of(context));

    final textAction = this.textAction;
    Widget buildHeader({double labelWidth = 0, double labelHeight = 0}) {
      return Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: actions.isEmpty && textAction == null
                  ? 0
                  : AppControlSize.touchTarget,
            ),
            child: Padding(
              padding: insets,
              child: Row(
                crossAxisAlignment: textAction == null
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (overline != null) ...[
                          Text(
                            overline.toUpperCase(),
                            style:
                                AppText.overline.copyWith(color: colors.muted),
                          ),
                          const SizedBox(height: AppSpacing.xsm),
                        ],
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: (titleStyle ?? AppText.display)
                              .copyWith(color: colors.ink),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.xsm),
                          Text(
                            subtitle,
                            style: AppText.sans(13, FontWeight.w500)
                                .copyWith(color: colors.muted),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: AppSpacing.md),
                    trailing!,
                  ],
                  if (textAction != null) ...[
                    const SizedBox(width: AppSpacing.md),
                    SizedBox(width: labelWidth, height: labelHeight),
                  ],
                  for (var index = 0; index < actions.length; index++) ...[
                    const SizedBox(width: AppSpacing.sm),
                    const SizedBox.square(
                      dimension: AppControlSize.iconButtonCompact,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (textAction != null)
            PositionedDirectional(
              bottom: insets.bottom,
              end: (Directionality.of(context) == TextDirection.ltr
                      ? insets.right
                      : insets.left) +
                  actions.length *
                      (AppControlSize.iconButtonCompact + AppSpacing.sm),
              width: labelWidth,
              height: math.max(labelHeight, AppControlSize.touchTarget),
              child: AppPressable(
                key: textAction.key,
                onTap: textAction.onTap,
                enabled: textAction.onTap != null,
                semanticsButton: true,
                semanticsLabel: textAction.label,
                pressedScale: 1,
                child: Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Text(
                      textAction.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppText.labelStrong.copyWith(color: colors.accent),
                    ),
                  ),
                ),
              ),
            ),
          for (final (index, action) in actions.indexed)
            Positioned.fill(
              child: _HeaderActionOverlay(
                action: action,
                index: actions.length - index - 1,
                padding: insets,
              ),
            ),
        ],
      );
    }

    if (textAction == null) return buildHeader();
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = math.max<double>(
          0,
          constraints.maxWidth -
              insets.horizontal -
              actions.length *
                  (AppControlSize.iconButtonCompact + AppSpacing.sm),
        );
        final textPainter = TextPainter(
          text: TextSpan(text: textAction.label, style: AppText.labelStrong),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          locale: Localizations.maybeLocaleOf(context),
          maxLines: 2,
          ellipsis: '…',
        )..layout(maxWidth: availableWidth * .45);
        final labelWidth = math.max<double>(
          AppControlSize.touchTarget,
          textPainter.width,
        );
        final labelHeight = textPainter.height + AppSpacing.sm * 2;
        textPainter.dispose();
        return buildHeader(labelWidth: labelWidth, labelHeight: labelHeight);
      },
    );
  }
}

class _HeaderActionOverlay extends StatelessWidget {
  const _HeaderActionOverlay({
    required this.action,
    required this.index,
    required this.padding,
  });

  final AppHeaderAction action;
  final int index;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    const visualSize = AppControlSize.iconButtonCompact;
    const targetSize = AppControlSize.touchTarget;
    const spare = targetSize - visualSize;
    final direction = Directionality.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final rowHeight = constraints.maxHeight - padding.vertical;
        final visualTop = padding.top + (rowHeight - visualSize) / 2;
        final targetTop = (visualTop - spare / 2)
            .clamp(0.0, math.max(0.0, constraints.maxHeight - targetSize))
            .toDouble();
        final visualEnd =
            (direction == TextDirection.ltr ? padding.right : padding.left) +
                index * (visualSize + AppSpacing.sm);
        final targetEnd = math.max<double>(0, visualEnd - spare / 2);
        return Stack(
          children: [
            PositionedDirectional(
              top: targetTop,
              end: targetEnd,
              width: targetSize,
              height: targetSize,
              child: AppHeaderCircleButton(
                action: action,
                visualAlignment: AlignmentDirectional(
                  1 - 2 * (visualEnd - targetEnd) / spare,
                  2 * (visualTop - targetTop) / spare - 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AppHeaderPillButton extends StatelessWidget {
  const AppHeaderPillButton({
    required this.label,
    super.key,
    this.onTap,
    this.trailingIcon = AppLineIcon.chevronD,
    this.background,
  });

  final String label;
  final VoidCallback? onTap;
  final AppLineIcon? trailingIcon;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = trailingIcon;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsButton: true,
      child: Container(
        height: AppControlSize.iconButtonCompact,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sectionGap),
        decoration: BoxDecoration(
          color: background ?? colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.labelStrong.copyWith(color: colors.ink),
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: AppSpacing.xsm),
              AppLineIconWidget(
                icon,
                size: AppIconSize.xs,
                color: colors.muted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
