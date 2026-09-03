import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_list_group.dart';
import 'package:flutter/widgets.dart';

class AppSettingsSection extends StatelessWidget {
  const AppSettingsSection({required this.children, super.key, this.title});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final titleText = title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (titleText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xxs),
            child: Text(
              titleText.toUpperCase(),
              style: AppText.overline.copyWith(color: colors.muted),
            ),
          ),
          const SizedBox(height: AppSpacing.gap),
        ],
        AppListGroup(showDividers: false, children: children),
      ],
    );
  }
}
