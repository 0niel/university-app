import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:app_ui/src/widgets/forms/app_form_metrics.dart';
import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.controller,
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.height = AppControlSize.search,
    this.borderRadius = AppRadius.full,
    this.fillColor,
    this.onCanvas = false,
    this.accentIconWhenEmpty = false,
    this.trailing,
    this.trailingIcon,
    this.onTrailingTap,
    this.trailingSemanticLabel,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final double height;
  final double borderRadius;
  final Color? fillColor;
  final bool onCanvas;
  final bool accentIconWhenEmpty;
  final Widget? trailing;
  final AppLineIcon? trailingIcon;
  final VoidCallback? onTrailingTap;
  final String? trailingSemanticLabel;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = fillColor ?? (onCanvas ? colors.surface : colors.surface2);
    final wellColor = onCanvas ? colors.canvas : colors.surface;

    return Container(
      height: height,
      padding: const EdgeInsets.only(
        left: AppFormMetrics.searchInset,
        right: AppFormMetrics.trailingInset,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => AppLineIconWidget(
              AppLineIcon.search,
              size: AppIconSize.md,
              color: accentIconWhenEmpty && value.text.isEmpty
                  ? colors.accent
                  : colors.muted,
            ),
          ),
          const SizedBox(width: AppSpacing.gap),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              textInputAction: TextInputAction.search,
              textCapitalization: textCapitalization,
              keyboardType: keyboardType,
              cursorColor: colors.accent,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: AppText.bodyLarge.copyWith(color: colors.ink),
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: AppText.bodyLarge.copyWith(color: colors.muted),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) {
                return _AppSearchTrailing(
                  wellColor: wellColor,
                  trailing: trailing,
                  icon: trailingIcon,
                  onTap: onTrailingTap,
                  semanticsLabel: trailingSemanticLabel,
                );
              }
              return AppPressState(
                onTap: () {
                  controller.clear();
                  onChanged?.call('');
                  onClear?.call();
                },
                pressedScale: 0.92,
                semanticsButton: true,
                semanticsLabel:
                    MaterialLocalizations.of(context).deleteButtonTooltip,
                builder: (context, {required pressed}) => SizedBox.square(
                  dimension: AppControlSize.touchTarget,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox.square(
                      dimension: AppFormMetrics.searchTrailingSize,
                      child: Center(
                        child: AppLineIconWidget(
                          AppLineIcon.close,
                          size: AppFormMetrics.searchIcon,
                          color: colors.muted,
                          strokeWidth: 2.2,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AppSearchTrailing extends StatelessWidget {
  const _AppSearchTrailing({
    required this.wellColor,
    this.trailing,
    this.icon,
    this.onTap,
    this.semanticsLabel,
  });

  final Color wellColor;
  final Widget? trailing;
  final AppLineIcon? icon;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final trailing = this.trailing;
    if (trailing != null) return trailing;
    final icon = this.icon;
    if (icon == null) return const SizedBox.shrink();
    return AppPressState(
      onTap: onTap,
      pressedScale: 0.92,
      semanticsButton: onTap != null,
      semanticsLabel:
          semanticsLabel ?? MaterialLocalizations.of(context).moreButtonTooltip,
      builder: (context, {required pressed}) => SizedBox.square(
        dimension: AppControlSize.touchTarget,
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: AppFormMetrics.searchTrailingSize,
            height: AppFormMetrics.searchTrailingSize,
            decoration: BoxDecoration(
              color: pressed ? colors.surface2 : wellColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppLineIconWidget(
                icon,
                size: AppFormMetrics.searchIcon,
                color: colors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
