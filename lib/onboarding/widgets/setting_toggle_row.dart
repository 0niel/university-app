import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class SettingToggleRow extends StatelessWidget {
  const SettingToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sectionGap,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.sans(15, FontWeight.w600).copyWith(
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      style: AppText.sans(12.5, FontWeight.w500).copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const SizedBox(
                width: AppControlSize.switchWidth,
                height: AppControlSize.switchHeight,
              ),
            ],
          ),
        ),
        PositionedDirectional(
          end: AppSpacing.lg,
          top: 0,
          bottom: 0,
          child: Center(
            child: AppSwitch(
              value: value,
              onChanged: onChanged,
              semanticsLabel: title,
            ),
          ),
        ),
      ],
    );
  }
}
