import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/widgets.dart';

class AppPrivacyChip extends StatelessWidget {
  const AppPrivacyChip({
    required this.icon,
    required this.label,
    super.key,
  });

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gap,
        vertical: AppSpacing.xsm,
      ),
      decoration: BoxDecoration(
        color: colors.lectureTint,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLineIconWidget(
            AppLineIcon.check,
            size: AppIconSize.badge,
            color: colors.lecture,
            strokeWidth: 2.5,
          ),
          const SizedBox(width: AppSpacing.xsm),
          Text(
            '$icon $label',
            style: AppText.captionStrong.copyWith(color: colors.lecture),
          ),
        ],
      ),
    );
  }
}
