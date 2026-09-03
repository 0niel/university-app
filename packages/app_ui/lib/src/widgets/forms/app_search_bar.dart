import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:app_ui/src/widgets/forms/app_form_metrics.dart';
import 'package:app_ui/src/widgets/forms/app_search_field.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    required this.controller,
    required this.hintText,
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
    this.autofocus = false,
    this.height = AppControlSize.search,
    this.onCanvas = false,
    this.trailing,
    this.trailingIcon = AppLineIcon.mic,
    this.onTrailingTap,
    this.trailingSemanticLabel,
  })  : onTap = null,
        isButton = false;

  const AppSearchBar.button({
    required this.hintText,
    required this.onTap,
    super.key,
    this.height = AppControlSize.search,
    this.onCanvas = false,
    this.trailing,
    this.trailingIcon = AppLineIcon.mic,
    this.onTrailingTap,
    this.trailingSemanticLabel,
  })  : controller = null,
        onChanged = null,
        onSubmitted = null,
        onClear = null,
        focusNode = null,
        autofocus = false,
        isButton = true;

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final bool autofocus;
  final double height;
  final bool onCanvas;
  final Widget? trailing;
  final AppLineIcon? trailingIcon;
  final VoidCallback? onTrailingTap;
  final String? trailingSemanticLabel;
  final VoidCallback? onTap;
  final bool isButton;

  @override
  Widget build(BuildContext context) {
    if (!isButton) {
      return AppSearchField(
        controller: controller!,
        hintText: hintText,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onClear: onClear,
        focusNode: focusNode,
        autofocus: autofocus,
        height: height,
        onCanvas: onCanvas,
        trailing: trailing,
        trailingIcon: trailingIcon,
        onTrailingTap: onTrailingTap,
        trailingSemanticLabel: trailingSemanticLabel,
      );
    }

    final colors = context.colors;
    final fill = onCanvas ? colors.surface : colors.surface2;
    final wellColor = onCanvas ? colors.canvas : colors.surface;
    final icon = trailingIcon;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    return AppPressState(
      onTap: onTap,
      semanticsLabel: onTrailingTap == null ? hintText : null,
      semanticsButton: true,
      builder: (context, {required pressed}) => AnimatedContainer(
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        height: height,
        padding: const EdgeInsets.only(
          left: AppFormMetrics.searchInset,
          right: AppFormMetrics.trailingInset,
        ),
        decoration: BoxDecoration(
          color: pressed ? colors.canvas : fill,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          children: [
            AppLineIconWidget(
              AppLineIcon.search,
              size: AppIconSize.md,
              color: colors.muted,
            ),
            const SizedBox(width: AppSpacing.gap),
            Expanded(
              child: Text(
                hintText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyLarge.copyWith(color: colors.muted),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (icon != null)
              AppPressState(
                onTap: onTrailingTap,
                semanticsButton: onTrailingTap != null,
                semanticsLabel: trailingSemanticLabel ??
                    MaterialLocalizations.of(context).moreButtonTooltip,
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
              ),
          ],
        ),
      ),
    );
  }
}
