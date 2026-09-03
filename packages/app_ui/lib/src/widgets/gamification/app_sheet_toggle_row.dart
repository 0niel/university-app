import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_divider.dart';
import 'package:app_ui/src/widgets/app_toggle.dart';
import 'package:flutter/widgets.dart';

class AppSheetToggleRow extends StatelessWidget {
  const AppSheetToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.isFirst = false,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFirst) const AppDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
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
