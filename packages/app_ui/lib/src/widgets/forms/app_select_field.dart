import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:app_ui/src/widgets/forms/app_field_label.dart';
import 'package:app_ui/src/widgets/forms/app_form_metrics.dart';
import 'package:flutter/material.dart';

class AppSelectField extends StatelessWidget {
  const AppSelectField({
    super.key,
    this.value,
    this.placeholder,
    this.label,
    this.onTap,
    this.leadingIcon,
    this.trailingIcon = AppLineIcon.chevronD,
    this.enabled = true,
    this.height = AppControlSize.field,
    this.borderRadius = AppRadius.field,
    this.fillColor,
    this.helperText,
  });

  final String? value;
  final String? placeholder;
  final String? label;
  final VoidCallback? onTap;
  final AppLineIcon? leadingIcon;
  final AppLineIcon trailingIcon;
  final bool enabled;
  final double height;
  final double borderRadius;
  final Color? fillColor;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = this.label;
    final helper = helperText;
    final value = this.value;
    final hasValue = value != null && value.isNotEmpty;
    final leadingIcon = this.leadingIcon;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) AppFieldLabel(label),
        AppPressState(
          onTap: enabled ? onTap : null,
          enabled: enabled,
          semanticsLabel: hasValue ? value : placeholder,
          semanticsButton: true,
          builder: (context, {required pressed}) => AnimatedContainer(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            height: height,
            padding: EdgeInsets.only(
              left: leadingIcon == null
                  ? AppFormMetrics.inset
                  : AppFormMetrics.leadingInset,
              right: AppFormMetrics.inset,
            ),
            decoration: BoxDecoration(
              color: !enabled
                  ? colors.canvas
                  : pressed
                      ? colors.canvas
                      : (fillColor ?? colors.surface2),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  AppLineIconWidget(
                    leadingIcon,
                    size: AppFormMetrics.leadingIcon,
                    color: colors.muted,
                  ),
                  const SizedBox(width: AppFormMetrics.leadingGap),
                ],
                Expanded(
                  child: Text(
                    hasValue ? value : (placeholder ?? ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body.copyWith(
                      color: !enabled
                          ? colors.muted2
                          : hasValue
                              ? colors.ink
                              : colors.muted2,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppLineIconWidget(
                  trailingIcon,
                  size: AppIconSize.sm,
                  color: colors.muted,
                  strokeWidth: 2.4,
                ),
              ],
            ),
          ),
        ),
        if (helper != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.fine),
            child: Text(
              helper,
              style: AppText.sans(
                AppFormMetrics.messageFontSize,
                FontWeight.w500,
                height: AppFormMetrics.messageLineHeight,
              ).copyWith(color: colors.muted),
            ),
          ),
      ],
    );
  }
}
