import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_divider.dart';
import 'package:app_ui/src/widgets/app_toggle.dart';
import 'package:flutter/widgets.dart';

class AppSettingsToggleRow extends StatelessWidget {
  const AppSettingsToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.leading,
    this.isFirst = false,
    this.isLast = false,
  });

  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? subtitle;
  final Widget? leading;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    final leadingWidget = leading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFirst)
          AppDivider(indent: leadingWidget != null ? 64 : AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              if (leadingWidget != null) ...[
                leadingWidget,
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppText.body.copyWith(color: colors.ink),
                    ),
                    if (subtitleText != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitleText,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AppSwitch(
                value: value,
                onChanged: onChanged,
                semanticsLabel: title,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
