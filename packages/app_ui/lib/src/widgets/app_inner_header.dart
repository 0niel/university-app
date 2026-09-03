import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:app_ui/src/widgets/app_screen_header.dart';
import 'package:flutter/widgets.dart';

class AppInnerHeader extends StatelessWidget {
  const AppInnerHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.onBack,
    this.backSemanticsLabel,
    this.actions = const <AppHeaderAction>[],
    this.trailingLabel,
    this.onTrailingLabelTap,
    this.padding,
    this.applyTopInset = true,
    this.titleStyle,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final String? backSemanticsLabel;
  final List<AppHeaderAction> actions;
  final String? trailingLabel;
  final VoidCallback? onTrailingLabelTap;
  final EdgeInsetsGeometry? padding;
  final bool applyTopInset;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final top = applyTopInset
        ? math.max(AppSpacing.screenTop, MediaQuery.paddingOf(context).top + 12)
        : 0.0;
    final subtitle = this.subtitle;
    final trailingLabel = this.trailingLabel;

    return Padding(
      padding: padding ??
          EdgeInsets.fromLTRB(
            AppSpacing.screen,
            top,
            AppSpacing.screen,
            AppSpacing.zero,
          ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final painter = trailingLabel == null
              ? null
              : (TextPainter(
                  text: TextSpan(
                    text: trailingLabel,
                    style: AppText.sans(13, FontWeight.w500),
                  ),
                  textDirection: Directionality.of(context),
                  textScaler: MediaQuery.textScalerOf(context),
                  locale: Localizations.maybeLocaleOf(context),
                )..layout());
          final available = math.max<double>(
            0,
            constraints.maxWidth -
                (onBack == null ? 0 : 56) -
                actions.length * 52 -
                12,
          );
          final trailingWidth = math.min(
            available * .55,
            math.max<double>(
              onTrailingLabelTap == null ? 0 : 44,
              (painter?.width ?? 0) + (onTrailingLabelTap == null ? 0 : 8),
            ),
          );
          painter?.dispose();
          return Row(
            children: [
              if (onBack != null) ...[
                AppPressable(
                  onTap: onBack,
                  semanticsLabel: backSemanticsLabel,
                  semanticsButton: true,
                  child: Container(
                    width: AppControlSize.iconButton,
                    height: AppControlSize.iconButton,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: AppLineIconWidget(
                      AppLineIcon.chevronL,
                      size: AppIconSize.md,
                      color: colors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (titleStyle ?? AppText.displaySmall)
                          .copyWith(color: colors.ink),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailingLabel != null) ...[
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: trailingWidth,
                  child: AppPressable(
                    onTap: onTrailingLabelTap,
                    semanticsLabel: trailingLabel,
                    semanticsButton: onTrailingLabelTap != null,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 44),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: onTrailingLabelTap == null
                              ? AppSpacing.zero
                              : AppSpacing.xs,
                        ),
                        child: Center(
                          child: Text(
                            trailingLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.sans(13, FontWeight.w500)
                                .copyWith(color: colors.muted),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              for (final action in actions) ...[
                const SizedBox(width: AppSpacing.sm),
                AppHeaderCircleButton(
                  action: action,
                  size: AppControlSize.iconButton,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
