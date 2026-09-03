import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_card.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.label,
    required this.children,
    this.topPadding = 26,
    super.key,
  });

  final String label;
  final List<Widget> children;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen + 2,
            topPadding,
            AppSpacing.screen + 2,
            12,
          ),
          child: Text(
            label.toUpperCase(),
            style: AppText.overline.copyWith(
              color: context.colors.muted,
              height: 1.3,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
          ),
          child: SettingsCard(children: children),
        ),
      ],
    );
  }
}
